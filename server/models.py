from sqlalchemy import (
    JSON, Boolean, Column, ForeignKey, Integer, String, DateTime, Float, Enum, Text, ARRAY
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
from database import Base


# ✅ User Model
class User(Base):
    __tablename__ = "users"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    uid = Column(String, unique=True, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    full_name = Column(String, nullable=True)
    phone_number = Column(String, nullable=True)
    location = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    is_active = Column(Boolean, default=True)
    maxed_business = Column(Boolean, default=False)
    maxed_services = Column(Boolean, default=False)
    # Relationships
    businesses = relationship("Business", back_populates="owner", lazy="select")  # Change from dynamic
    services = relationship("Service", back_populates="owner", lazy="select")  # Change from dynamic
    bookings = relationship("Booking", back_populates="user", lazy="select")  # Change from dynamic
    # Default empty list for saved businesses and liked products
    saved_businesses = Column(ARRAY(UUID(as_uuid=True)), default=[])
    liked_products = Column(ARRAY(UUID(as_uuid=True)), default=[])

class Business(Base):
    __tablename__ = "businesses"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    owner_id = Column(String, ForeignKey("users.uid", ondelete="CASCADE"))
    name = Column(String, index=True, nullable=False)
    description = Column(Text, nullable=True)
    category = Column(String, nullable=False)
    business_type = Column(String, nullable=False)
    location = Column(String, nullable=False)
    address = Column(String, nullable=False)
    phone = Column(String, nullable=True)
    email = Column(String, nullable=True)
    website = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)
    allows_delivery = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    # Relationships
    owner = relationship("User", back_populates="businesses")  # Default is fine
    services = relationship("Service", back_populates="business", lazy="select")  # Change from dynamic
    products = relationship("Product", back_populates="business", lazy="select")  # Change from dynamic

class Service(Base):
    __tablename__ = "services"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    business_id = Column(UUID(as_uuid=True), ForeignKey("businesses.id", ondelete="CASCADE"))
    owner_id = Column(String, ForeignKey("users.uid", ondelete="CASCADE"))
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    duration = Column(Integer, nullable=False)
    price = Column(Float, nullable=False)
    is_active = Column(Boolean, default=True)
    available_days = Column(JSON, nullable=False, default=list)
    available_hours = Column(JSON, nullable=False, default=list)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    business = relationship("Business", back_populates="services")  # Change from joined
    bookings = relationship("Booking", back_populates="service", lazy="select")  # Change from dynamic
    owner = relationship("User", back_populates="services")  # Change from joined

# ✅ Booking Model
class Booking(Base):
    __tablename__ = "bookings"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    service_id = Column(UUID(as_uuid=True), ForeignKey("services.id", ondelete="CASCADE"))
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    start_time = Column(DateTime(timezone=True), nullable=False)
    end_time = Column(DateTime(timezone=True), nullable=False)
    status = Column(Enum("pending", "confirmed", "cancelled", "completed", name="booking_status"), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    service = relationship("Service", back_populates="bookings", lazy="joined")
    user = relationship("User", back_populates="bookings", lazy="joined")

# ✅ Product Model
class Product(Base):
    __tablename__ = "products"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    business_id = Column(UUID(as_uuid=True), ForeignKey("businesses.id", ondelete="CASCADE"))
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)
    stock = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    business = relationship("Business", back_populates="products", lazy="joined")

# ✅ MarketplaceItem Model
class MarketplaceItem(Base):
    __tablename__ = "marketplace_items"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    seller_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)
    condition = Column(Enum("new", "like_new", "good", "fair", "poor", name="item_condition"), nullable=False)
    images = Column(ARRAY(String), default=[])
    is_sold = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())