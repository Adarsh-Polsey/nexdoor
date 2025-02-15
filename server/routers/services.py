from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Create a New Service (Only Business Owners)
@router.post("/create_service", response_model=schemas.Service)
def create_service(
    service: schemas.ServiceCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Creates a service under the logged-in user's business."""
    business = db.query(models.Business).filter(models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to create services")

    db_service = models.Service(**service.model_dump(), business_id=business.id)
    db.add(db_service)
    db.commit()
    db.refresh(db_service)
    return db_service

# ✅ List Services (With Filters)
@router.get("/list_services", response_model=List[schemas.Service])
def list_services(
    skip: int = 0,
    limit: int = 100,
    business_id: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Fetches services with optional business and search filters."""
    query = db.query(models.Service)

    if business_id:
        query = query.filter(models.Service.business_id == business_id)

    if search:
        search = search.strip()
        query = query.filter(
            or_(
                func.similarity(models.Service.name, search) > 0.3,
                func.similarity(models.Service.description, search) > 0.3
            )
        ).order_by(func.similarity(models.Service.name, search).desc())

    return query.offset(skip).limit(limit).all()

# ✅ Get Service by ID
@router.get("/get_service/{service_id}", response_model=schemas.Service)
def get_service(
    service_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Retrieves a service by its ID."""
    service = db.query(models.Service).filter(models.Service.id == service_id).first()

    if not service:
        raise HTTPException(status_code=404, detail="Service not found")

    return service

# ✅ Update Service (Only Business Owners)
@router.put("/update_service/{service_id}", response_model=schemas.Service)
def update_service(
    service_id: str,
    service_update: schemas.ServiceCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows business owners to update their services."""
    db_service = db.query(models.Service).filter(models.Service.id == service_id).first()

    if not db_service:
        raise HTTPException(status_code=404, detail="Service not found")

    # Ensure the user owns the business that created the service
    business = db.query(models.Business).filter(models.Business.id == db_service.business_id, models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to update this service")

    for key, value in service_update.model_dump().items():
        setattr(db_service, key, value)

    db.commit()
    db.refresh(db_service)
    return db_service

# ✅ Delete Service (Only Business Owners)
@router.delete("/delete_service/{service_id}", status_code=204)
def delete_service(
    service_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows business owners to delete their services."""
    service = db.query(models.Service).filter(models.Service.id == service_id).first()

    if not service:
        raise HTTPException(status_code=404, detail="Service not found")

    # Ensure the user owns the business that created the service
    business = db.query(models.Business).filter(models.Business.id == service.business_id, models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to delete this service")

    db.delete(service)
    db.commit()