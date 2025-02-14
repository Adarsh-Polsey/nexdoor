from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

@router.post("/create_booking")
def create_booking(booking: schemas.BookingCreate, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    db_booking = models.Booking(**booking.dict())
    db.add(db_booking)
    db.commit()
    db.refresh(db_booking)
    return db_booking

@router.get("/list_booking")
def list_bookings(
    skip: int = 0,
    limit: int = 100,
    user_id: str = None,
    service_id: str = None,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    query = db.query(models.Booking)
    if user_id:
        query = query.filter(models.Booking.user_id == user_id)
    if service_id:
        query = query.filter(models.Booking.service_id == service_id)
    bookings = query.offset(skip).limit(limit).all()
    return bookings

@router.get("/get_booking/{booking_id}")
def get_booking(booking_id: str, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()
    if booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")
    return booking

@router.post("/update_booking/{booking_id}")
def update_booking(
    booking_id: str,
    booking: schemas.BookingCreate,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    db_booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()
    if db_booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")
    
    for key, value in booking.dict().items():
        setattr(db_booking, key, value)
    
    db.commit()
    db.refresh(db_booking)
    return db_booking

@router.post("/{booking_id}/status")
def update_booking_status(
    booking_id: str,
    status: schemas.BookingStatus,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()
    if booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")
    
    booking.status = status
    db.commit()
    db.refresh(booking)
    return booking

@router.post("/delete_booking/{booking_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_booking(booking_id: str, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    booking = db.query(models.Booking).filter(models.Booking.id == booking_id).first()
    if booking is None:
        raise HTTPException(status_code=404, detail="Booking not found")
    
    db.delete(booking)
    db.commit()
    return None