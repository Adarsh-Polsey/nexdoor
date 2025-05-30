from pydantic import BaseModel, EmailStr, UUID4, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum

# ✅ User Schemas
class UserBase(BaseModel):
    email: EmailStr
class UserCreate(UserBase):
    uid:str
    full_name: str
    phone_number: str
    location: str

class User(UserBase):
    id: UUID4
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True

class ServiceBase(BaseModel):
    name: str
    description: Optional[str] = None
    duration: int  # In minutes
    price: float
    available_days: List[str] = Field(default_factory=list)  # List of days (e.g., ["Monday", "Tuesday"])
    available_hours: List[str] = Field(default_factory=list)  # List of hours (e.g., ["09:00-12:00", "14:00-18:00"])

# ✅ Business Schemas
class BusinessBase(BaseModel):
    name: str
    description: Optional[str] = None
    category: str
    business_type: str
    location: str
    address: str
    phone: Optional[str] = None
    email: Optional[EmailStr] = None
    website: Optional[str] = None
    allows_delivery: bool = False

class Service(ServiceBase):
    id: UUID4
    business_id: UUID4
    is_active: bool = True
    created_at: datetime  # Timestamp when the service was created
    updated_at: Optional[datetime] = None  # Timestamp when the service was last updated

    class Config:
        from_attributes = True
        
class BusinessCreate(BusinessBase):
    services: List[ServiceBase]
class Business(BusinessBase):
    id: UUID4
    owner_id: str
    is_active: bool = True
    created_at: datetime
    updated_at: Optional[datetime] = None
    services: List[Service] = []  

    class Config:
        from_attributes = True

class ServiceCreate(ServiceBase):
    pass

# ✅ Booking Status Enum
class BookingStatus(str, Enum):
    pending = "pending"
    confirmed = "confirmed"
    cancelled = "cancelled"
    completed = "completed"

# ✅ Booking Schemas
class BookingBase(BaseModel):
    service_id: UUID4
    start_time: datetime
    end_time: datetime

class BookingCreate(BookingBase):
    pass  # No extra fields needed for creation

class Booking(BookingBase):
    id: UUID4
    user_id: UUID4
    status: BookingStatus
    created_at: datetime

    class Config:
        from_attributes = True
