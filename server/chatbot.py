import os
import json
import subprocess
import sys
import re
from typing import Dict, Any, Optional
from datetime import datetime
from dotenv import load_dotenv
from fastapi import APIRouter, Query, Depends
from sqlalchemy.orm import Session
from database import engine, get_db
from sqlalchemy import text

router = APIRouter()

if os.getenv("GITHUB_ACTIONS") is None:
   load_dotenv()
   API_KEY=os.getenv("APIKEY")
else :
    API_KEY = os.environ["APIKEY"]
if not API_KEY:
    raise ValueError(" Missing API key")

def call_gemini_api(api_key: str, prompt: str, model: str = "gemini-2.0-flash") -> Optional[Dict[str, Any]]:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    
    data = {
        "contents": [
            {
                "parts": [
                    {"text": prompt}
                ]
            }
        ]
    }
    
    try:
        result = subprocess.run(
            ["curl", "-X", "POST", "-H", "Content-Type: application/json",
             "-d", json.dumps(data), url],
            capture_output=True, text=True, check=True
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"API call failed: {e}")
        print(f"stderr: {e.stderr}")
        return None
    except json.JSONDecodeError as e:
        print(f"Failed to parse API response: {e}")
        return None

def create_sql_query(query: str) -> str:
    return f"""
    You are a SQL query generator that creates valid SQL for the following question: {query}
    
    IMPORTANT: Use ONLY the tables and fields listed below. Do not include any fields not explicitly listed here:
    
    Tables and their EXACT fields:
    businesses: id, owner_id, name, description, category, business_type, location, address, phone, email, website, allows_delivery
    services: id, business_id, owner_id, name, description, duration, price, is_active, available_days, available_hours
    
    Rules:
    - Return ONLY the raw SQL query without any markdown, comments, or explanations
    -if he asks about businesses, use the businesses table entirely without any sorting or any other attributes and i will find the answer from the results and same for service
    - Do not use any fields not listed above (e.g., do not use rating, created_at, etc.)
    - Generate a valid SQL query that works with PostgreSQL
    - If you cannot generate a valid query with the available fields, use the fields that are most relevant
    - Only include SQL syntax, no backticks, no code blocks
    
    Example response format:
    SELECT column1, column2 FROM table WHERE condition;
    """

def create_query_prompt(data: str,question: str) -> str:
    return f"""
    we have a data and the user's question
    data: {data}
    question: {question}
    -mix up the data and create a responding answer to the user's question
    -Generate a human like response that could be directly given to the user, no extra make-up
    -answer should be in a human-like intercation
    """

def format_gemini_response(response):
    try:
        # Check if response has the expected structure
        if (response and 'candidates' in response and 
            response['candidates'] and 
            'content' in response['candidates'][0] and 
            'parts' in response['candidates'][0]['content'] and
            response['candidates'][0]['content']['parts']):
            
            # Extract the text from the first candidate's first part
            answer_text = response['candidates'][0]['content']['parts'][0]['text']
            
            return {"answer": answer_text}
        else:
            # Return a newbie-like response when data is not found or structure is unexpected
            return {
                "answer": "I'm still learning about businesses in this area! I don't have specific data to answer your question yet. Maybe try checking online reviews or asking locals for recommendations? I'd be happy to help with more specific questions if you have any!"
            }
    except Exception as e:
        # Handle any unexpected errors
        print(f"Error formatting Gemini response: {str(e)}")
        return {
            "answer": "Oops! I ran into a technical issue while processing your question. I'm still learning how to answer questions like this. Could you try asking in a different way?"
        }

def retrieve_data_from_db(query: str, db: Session) -> Optional[Dict[str, Any]]:
    """Retrieve data from the database."""
    try:
        # Get an sql query prompt
        sql_prompt = create_sql_query(query)
        # calling gemini for sqlquery
        gemini_response = call_gemini_api(API_KEY, sql_prompt)
        print("🛑", gemini_response)
        
        # Extract the SQL query from the Gemini response
        if gemini_response and 'candidates' in gemini_response and gemini_response['candidates']:
            candidate = gemini_response['candidates'][0]
            if 'content' in candidate and 'parts' in candidate['content']:
                # Extract the SQL query text from the response
                sql_text = candidate['content']['parts'][0]['text']
                # Remove markdown code block formatting if present
                sql_query = re.sub(r'```sql\n|\n```', '', sql_text).strip()
                
                # Use SQLAlchemy's text() function to create a SQL expression
                sql_expression = text(sql_query)
                
                # Execute the query
                result = db.execute(sql_expression)
                print("🛑 SQL Query Executed:", sql_query)
                
                # Fetch the results
                rows = result.fetchall()
                print("🛑 Query Results:", rows)
                
                # Return the results
                return rows
            
        return None
    except Exception as e:
        print(f"Error retrieving data from database: {e}")
        return None

def clean_and_format_response(response_text):
    if "\"" in response_text:
        # Extract content between double quotes, which contains the actual response
        try:
            # Find the first and last double quote
            start_idx = response_text.find("\"")
            end_idx = response_text.rfind("\"")
            
            if start_idx != -1 and end_idx != -1 and end_idx > start_idx:
                # Extract the content between quotes
                clean_text = response_text[start_idx+1:end_idx]
                return clean_text
        except Exception as e:
            print(f"Error extracting response content: {e}")
    
    # If we can't extract cleanly, remove obvious instructions and return
    clean_text = response_text
    
    # Remove common instruction patterns
    prefixes_to_remove = [
        "Okay, here's a human-like response to the user's question, mixing up the data and presenting it conversationally:",
        "Here's a human-like response:",
        "Human-like response:"
    ]
    
    for prefix in prefixes_to_remove:
        if clean_text.startswith(prefix):
            clean_text = clean_text[len(prefix):].strip()
    
    return clean_text

@router.get('/chat_ai')
async def chat_ai(query: str = Query(..., description="Enter your query"), db: Session = Depends(get_db)):
    try:
        # Retrieve data from database
        data = retrieve_data_from_db(query, db)
        if data is None:
            # Direct Gemini response when no database data is found
            direct_response = call_gemini_api(API_KEY, query)
            formatted_response = format_gemini_response(direct_response)
            return {"answer": formatted_response["answer"]}
            
        # Create prompt with the database data
        query_with_data = create_query_prompt(data.__str__(), query)
        
        # Call the Gemini API
        response = call_gemini_api(API_KEY, query_with_data)
        if response is None:
            return {"answer": "Failed to get a valid response from the API"}
            
        # Format the response
        formatted_response = format_gemini_response(response)
        
        # Clean the formatted response
        cleaned_text = clean_and_format_response(formatted_response["answer"])
        
        # Return the answer in the expected format
        return {"answer": cleaned_text}
    except Exception as e:
        return {"answer": f"Error: {str(e)}"}