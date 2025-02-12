from pydantic import BaseModel

class BusinessCreate(BaseModel):
    business_name: str
    owner_name: str
    email: str
    phone_number: str
    address: str
    business_type: str
    password: str

class BusinessEdit(BaseModel):
    business_name: str = None
    phone_number: str = None
    address: str = None
    business_type: str = None
    delivery_available: bool = None
    opening_hours: dict = None


