from datetime import datetime
import traceback
import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
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
    try:
        if user.maxed_business:
            raise HTTPException(status_code=403, detail="Not authorized to create a business")

        # ✅ Explicitly generate UUID before adding to DB
        business_id = uuid.uuid4()

        # Create the business
        db_business = models.Business(
            id=business_id,  # ✅ Explicitly set ID
            **business.model_dump(exclude={"services"}),
            owner_id=user.uid,
            created_at=datetime.now(),
            updated_at=datetime.now(),
        )
        db.add(db_business)
        db.commit()  # ✅ Ensure it's stored in DB
        db.refresh(db_business)  # ✅ Ensure ID is assigned

        user.maxed_business = True

        # ✅ Now business_id is guaranteed to exist
        for service_data in business.services:
            db_service = models.Service(
                **service_data.model_dump(),
                owner_id=user.uid,
                business_id=business_id,  # ✅ Now it's guaranteed to be set
                created_at=datetime.now(),
                updated_at=datetime.now(),
            )
            db.add(db_service)

        db.commit()
        user.maxed_services = True
        return db_business

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail={"message": "Failed to create business"})

# ✅ List Businesses (With Optional Search)
@router.get("/list_businesses", response_model=List[schemas.Business])
def list_businesses(
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    try:
        query = db.query(models.Business).options(joinedload(models.Business.services))

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

    except Exception as e:
        raise HTTPException(status_code=500, detail={ "message": "Failed to list businesses"})

# ✅ Get Business by ID
@router.get("/get_business/{business_id}", response_model=schemas.Business)
@router.get("/get_business", response_model=schemas.Business)
def get_business(
    business_id: str = None,  
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    try:
        if business_id:
            business = db.query(models.Business).filter(models.Business.id == business_id).first()
            if not business:
                raise HTTPException(status_code=404, detail="Business not found")
        else:
            business = db.query(models.Business).filter(models.Business.owner_id == user.uid).first()
            if not business:
                raise HTTPException(status_code=404, detail="No business found for the current user")

        return business

    except Exception as e:
        raise HTTPException(status_code=500, detail={ "message": "Failed to get business"})

# ✅ Update Business (Only Owner Can Update)
@router.post("/update_business", response_model=schemas.Business)
def update_business(
    business_update: schemas.BusinessCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    try:
        # Fetch the business owned by the current user
        db_business = db.query(models.Business).filter(models.Business.owner_id == user.uid).first()

        if not db_business:
            raise HTTPException(
                status_code=404, 
                detail=f"Business not found - user.uid: {user.uid}, owner_id: {business_update.owner_id}"
            )

        # Authorization check
        if db_business.owner_id != user.uid:
            raise HTTPException(status_code=403, detail="Not authorized to update this business")

        # Update fields dynamically
        business_data=business_update.model_dump(exclude_unset=True)
        for key, value in business_data.items():
            if hasattr(db_business, key):
                setattr(db_business, key, value)

        db.commit()
        db.refresh(db_business)
        return db_business

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail={
                "message": "Failed to update business",
                "error":f"{e}",
                "trace": traceback.format_exc()
            }
        )

# ✅ Delete Business (Only Owner Can Delete)
@router.post("/delete_business/{business_id}", status_code=204)
def delete_business(
    business_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    try:
        """Allows the business owner to delete their business."""
        business = db.query(models.Business).filter(models.Business.id == business_id).first()

        if not business:
            raise HTTPException(status_code=404, detail="Business not found")

        if business.owner_id != user.id:
            raise HTTPException(status_code=403, detail="Not authorized to delete this business")

        db.delete(business)
        db.commit()
    except Exception as e:
        raise HTTPException(status_code=500, detail={ "message": "Failed to delete business"})