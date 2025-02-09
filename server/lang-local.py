# from langchain_community.agent_toolkits.sql.toolkit import SQLDatabaseToolkit  
# from langchain_community.utilities.sql_database import SQLDatabase  
# from langchain_google_vertexai import VertexAI
# from langchain import hub


# db = SQLDatabase.from_uri("sqlite:///Chinook.db")  
# llm = VertexAI(temperature=0)  
# toolkit = SQLDatabaseToolkit(db=db, llm=llm)

# tools = toolkit.get_tools()

# # load a system prompt for our agent.
# prompt_template = hub.pull("langchain-ai/sql-agent-system-prompt")

# assert len(prompt_template.messages) == 1
# prompt_template.messages[0].pretty_print()

# system_message = prompt_template.format(dialect="SQLite", top_k=5)


from langchain_google_vertexai import VertexAI

# Initialize VertexAI with a specific model
llm = VertexAI(model_name="text-bison@001",max_output_tokens=1024,temperature=0)

# Generate a response
response = llm.invoke("What is the capital of France?")
print(response)