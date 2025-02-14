from pydantic import BaseModel, EmailStr, UUID4
from typing import Optional, List
from datetime import datetime
from enum import Enum

class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None
    phone_number: Optional[str] = None
    location: Optional[str] = None

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: UUID4
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True

class BusinessBase(BaseModel):
    name: str
    description: Optional[str] = None
    category: str
    address: str
    phone: Optional[str] = None
    email: Optional[EmailStr] = None
    website: Optional[str] = None
    allows_delivery: bool = False

class BusinessCreate(BusinessBase):
    pass

class Business(BusinessBase):
    id: UUID4
    owner_id: UUID4
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class ServiceBase(BaseModel):
    name: str
    description: Optional[str] = None
    duration: int
    price: float
    is_active: bool = True

class ServiceCreate(ServiceBase):
    business_id: UUID4

class Service(ServiceBase):
    id: UUID4
    business_id: UUID4

    class Config:
        from_attributes = True

class BookingStatus(str, Enum):
    pending = "pending"
    confirmed = "confirmed"
    cancelled = "cancelled"
    completed = "completed"

class BookingBase(BaseModel):
    service_id: UUID4
    start_time: datetime
    end_time: datetime

class BookingCreate(BookingBase):
    pass

class Booking(BookingBase):
    id: UUID4
    user_id: UUID4
    status: BookingStatus
    created_at: datetime

    class Config:
        from_attributes = True

class ProductBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    stock: int = 0
    is_active: bool = True

class ProductCreate(ProductBase):
    business_id: UUID4

class Product(ProductBase):
    id: UUID4
    business_id: UUID4
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class ItemCondition(str, Enum):
    new = "new"
    like_new = "like_new"
    good = "good"
    fair = "fair"
    poor = "poor"

class MarketplaceItemBase(BaseModel):
    title: str
    description: Optional[str] = None
    price: float
    condition: ItemCondition
    images: List[str] = []

class MarketplaceItemCreate(MarketplaceItemBase):
    pass

class MarketplaceItem(MarketplaceItemBase):
    id: UUID4
    seller_id: UUID4
    is_sold: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True