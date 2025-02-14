from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
import models, schemas
from database import get_db

router = APIRouter()

@router.post("/create_business")
def create_business(business: schemas.BusinessCreate, db: Session = Depends(get_db)):
    db_business = models.Business(**business.dict())
    db.add(db_business)
    db.commit()
    db.refresh(db_business)
    return db_business

@router.get("/list_businesses")
def list_businesses(
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    query = db.query(models.Business)
    
    if search:
        search = search.strip()
        query = query.filter(
            or_(
                func.similarity(models.Business.name, search) > 0.3,
                func.similarity(models.Business.description, search) > 0.3,
                func.similarity(models.Business.category, search) > 0.3
            )
        ).order_by(func.similarity(models.Business.name, search).desc())
    
    businesses = query.offset(skip).limit(limit).all()
    return businesses

@router.get("/get_business/{business_id}")
def get_business(business_id: str, db: Session = Depends(get_db)):
    business = db.query(models.Business).filter(models.Business.id == business_id).first()
    if business is None:
        raise HTTPException(status_code=404, detail="Business not found")
    return business

@router.post("/update_business/{business_id}")
def update_business(
    business_id: str,
    business: schemas.BusinessCreate,
    db: Session = Depends(get_db)
):
    db_business = db.query(models.Business).filter(models.Business.id == business_id).first()
    if db_business is None:
        raise HTTPException(status_code=404, detail="Business not found")
    
    for key, value in business.dict().items():
        setattr(db_business, key, value)
    
    db.commit()
    db.refresh(db_business)
    return db_business

@router.post("/delete_business/{business_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_business(business_id: str, db: Session = Depends(get_db)):
    business = db.query(models.Business).filter(models.Business.id == business_id).first()
    if business is None:
        raise HTTPException(status_code=404, detail="Business not found")
    
    db.delete(business)
    db.commit()
    return None