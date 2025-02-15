from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Create Business
@router.post("/create_business", response_model=schemas.Business)
def create_business(
    business: schemas.BusinessCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Creates a business and assigns it to the logged-in user."""
    db_business = models.Business(**business.model_dump(), owner_id=user.id)
    user=db.query(models.User).filter(models.User.uid == user.uid).first()
    if user.is_business:
        raise HTTPException(status_code=403, detail="User already has a business")
    user.is_business=True
    db.add(db_business)
    db.commit()
    db.refresh(db_business)
    return db_business

# ✅ List Businesses (With Optional Search)
@router.get("/list_businesses", response_model=List[schemas.Business])
def list_businesses(
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Fetches all businesses, with optional fuzzy search."""
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

    return query.offset(skip).limit(limit).all()

# ✅ Get Business by ID
@router.get("/get_business/{business_id}", response_model=schemas.Business)
def get_business(
    business_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Retrieves a business by ID."""
    business = db.query(models.Business).filter(models.Business.id == business_id).first()

    if not business:
        raise HTTPException(status_code=404, detail="Business not found")

    return business

# ✅ Update Business (Only Owner Can Update)
@router.put("/update_business/{business_id}", response_model=schemas.Business)
def update_business(
    business_id: str,
    business_update: schemas.BusinessCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows the business owner to update their business details."""
    db_business = db.query(models.Business).filter(models.Business.id == business_id).first()

    if not db_business:
        raise HTTPException(status_code=404, detail="Business not found")

    if db_business.owner_id != user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this business")

    for key, value in business_update.dict().items():
        setattr(db_business, key, value)

    db.commit()
    db.refresh(db_business)
    return db_business

# ✅ Delete Business (Only Owner Can Delete)
@router.delete("/delete_business/{business_id}", status_code=204)
def delete_business(
    business_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows the business owner to delete their business."""
    business = db.query(models.Business).filter(models.Business.id == business_id).first()

    if not business:
        raise HTTPException(status_code=404, detail="Business not found")

    if business.owner_id != user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this business")

    db.delete(business)
    db.commit()