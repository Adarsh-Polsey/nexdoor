from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Create Booking
@router.post("/create_booking", response_model=schemas.Booking, status_code=status.HTTP_201_CREATED)
def create_booking(
    booking: schemas.BookingCreate, 
    db: Session = Depends(get_db), 
    user: models.User = Depends(get_current_user)
):
    """Creates a new booking and assigns it to the logged-in user."""
    
    db_booking = models.Booking(**booking.dict(), user_id=user.id)
    db.add(db_booking)
    db.commit()
    db.refresh(db_booking)

    return db_booking

# ✅ List Bookings (Filtered by User or Service)
@router.get("/list_booking", response_model=List[schemas.Booking])
def list_bookings(
    skip: int = 0, 
    limit: int = 100, 
    user_id: Optional[str] = None, 
    service_id: Optional[str] = None, 
    db: Session = Depends(get_db), 
    user: models.User = Depends(get_current_user)
):
    """Fetches bookings, optionally filtered by user or service."""
    
    query = db.query(models.Booking)
    if user_id:
        query = query.filter(models.Booking.user_id == user_id)
    if service_id:
        query = query.filter(models.Booking.service_id == service_id)

    bookings = query.offset(skip).limit(limit).all()
    return bookings

# ✅ Get Booking by ID
@router.get("/get_booking/{booking_id}", response_model=schemas.Booking)
def get_booking(
    booking_id: str, 
    db: Session = Depends(get_db), 
    user: models.User = Depends(get_current_user)
):
    """Retrieves a booking by its ID."""
    
    booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()

    if booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")

    return booking

# ✅ Update Booking
@router.put("/update_booking/{booking_id}", response_model=schemas.Booking)
def update_booking(
    booking_id: str, 
    booking_update: schemas.BookingCreate, 
    db: Session = Depends(get_db), 
    user: models.User = Depends(get_current_user)
):
    """Allows a user to update a booking's details."""

    db_booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()

    if db_booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")

    for key, value in booking_update.dict().items():
        setattr(db_booking, key, value)

    db.commit()
    db.refresh(db_booking)
    return db_booking

# ✅ Update Booking Status
@router.patch("/{booking_id}/status", response_model=schemas.Booking)
def update_booking_status(
    booking_id: str, 
    status: schemas.BookingStatus, 
    db: Session = Depends(get_db), 
    user: models.User = Depends(get_current_user)
):
    """Updates the booking status."""

    booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()

    if booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")

    booking.status = status.value  # If BookingStatus is an Enum
    db.commit()
    db.refresh(booking)

    return booking

# ✅ Delete Booking
@router.delete("/delete_booking/{booking_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_booking(
    booking_id: str, 
    db: Session = Depends(get_db), 
    user: models.User = Depends(get_current_user)
):
    """Allows a user to delete a booking."""

    booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()

    if booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")

    db.delete(booking)
    db.commit()