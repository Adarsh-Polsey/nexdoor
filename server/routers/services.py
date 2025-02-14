from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

@router.post("/create_service")
def create_service(service: schemas.ServiceCreate, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    db_service = models.Service(**service.model_dump())
    db.add(db_service)
    db.commit()
    db.refresh(db_service)
    return db_service

@router.get("/list_services")
def list_services(
    skip: int = 0,
    limit: int = 100,
    business_id: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
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
    
    services = query.offset(skip).limit(limit).all()
    return services

@router.get("/get_service/{service_id}")
def get_service(service_id: str, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    service = db.query(models.Service).filter(models.Service.id == service_id).first()
    if service is None:
        raise HTTPException(status_code=404, detail="Service not found")
    return service

@router.post("/update_service/{service_id}")
def update_service(
    service_id: str,
    service: schemas.ServiceCreate,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    db_service = db.query(models.Service).filter(models.Service.id == service_id).first()
    if db_service is None:
        raise HTTPException(status_code=404, detail="Service not found")
    
    for key, value in service.model_dump().items():
        setattr(db_service, key, value)
    
    db.commit()
    db.refresh(db_service)
    return db_service

@router.post("/delete_service/{service_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_service(service_id: str, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    service = db.query(models.Service).filter(models.Service.id == service_id).first()
    if service is None:
        raise HTTPException(status_code=404, detail="Service not found")
    
    db.delete(service)
    db.commit()
    return None