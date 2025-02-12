from sqlalchemy import Column, Integer, String, Float,Boolean, JSON
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    name = Column(String)
    phone_number = Column(String)
    nearby_location = Column(String)
    password = Column(String)


class Business(Base):
    __tablename__ = 'businesses'
    id = Column(Integer, primary_key=True, index=True)
    business_name = Column(String)
    owner_name = Column(String)
    email = Column(String, unique=True, index=True)
    phone_number = Column(String)
    address = Column(String)
    business_type = Column(String)
    password = Column(String)
    delivery_available = Column(Boolean, default=False)
    opening_hours = Column(JSON, nullable=True)
