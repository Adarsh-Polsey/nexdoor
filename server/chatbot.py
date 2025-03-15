from fastapi import APIRouter, Query, Depends
from sqlalchemy.orm import Session
from langchain.chains import create_sql_query_chain
from langchain_community.utilities import SQLDatabase
from langchain_ollama import OllamaLLM
from database import engine, get_db
from sqlalchemy.sql import text

router = APIRouter()


db = SQLDatabase(engine) 

llm = OllamaLLM(model="deepseek-coder:6.7b", temperature=0)

sql_chain = create_sql_query_chain(llm, db)


@router.get("/")
async def query_chatbot(user_query: str = Query(..., description="Enter natural language query"), db: Session = Depends(get_db)):
    try:
        ai_response = sql_chain.invoke({"question": user_query}).strip()
        print(f"Ai response: {ai_response}\nResponse finished")

        sql_query = ai_response.split(";")[0] + ";" if ";" in ai_response else ai_response

        if not sql_query.lower().startswith("select"):
            return llm.invoke(input=user_query)

        result = db.execute(text(sql_query))
        rows = result.fetchall()
        column_names = result.keys()
        data = [dict(zip(column_names, row)) for row in rows]

        cleaned_response = llm.invoke(f"Make this data human-readable: {data}")

        return {"sql_query": sql_query, "results": cleaned_response}

    except Exception as e:
        return {"response": f"Oops! Something went wrong: {str(e)}. Try again!"}
