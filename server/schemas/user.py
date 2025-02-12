from pydantic import BaseModel, EmailStr, Field
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr
    name: str = Field(..., min_length=2, max_length=50)
    phone_number: str = Field(..., pattern=r"^\+?\d{10,15}$")  # Updated from regex to pattern
    nearby_location: str = Field(..., min_length=3, max_length=100)

class UserCreate(UserBase):
    password: str = Field(..., min_length=6, max_length=100)

class UserResponse(UserBase):
    id: int

    class Config:
        from_attributes = True  # Enables ORM support