from fastapi import FastAPI
from routers import auth,business


app = FastAPI()
app.include_router(auth.router, prefix="/auth")
app.include_router(business.router, prefix="/business")

# Available endpoints:
# - POST /auth/login: Handles user login. Verifies email and password against the database.
# - POST /auth/signup: Handles user registration. Creates a new user in the database if the email is not already registered.
