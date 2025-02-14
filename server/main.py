from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session # type: ignore
from typing import List
import models, schemas
from routers import auth, businesses, services, bookings, products, marketplace

app = FastAPI(title="NexDoor")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(businesses.router, prefix="/api/businesses", tags=["Businesses"])
app.include_router(services.router, prefix="/api/services", tags=["Services"])
app.include_router(bookings.router, prefix="/api/bookings", tags=["Bookings"])
app.include_router(products.router, prefix="/api/products", tags=["Products"])
app.include_router(marketplace.router, prefix="/api/marketplace", tags=["Marketplace"])

@app.get("/")
def read_root():
    return {"message": "Welcome to Local Business Platform API"}