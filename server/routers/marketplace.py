from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Create Marketplace Item
@router.post("/create_marketplace_item", response_model=schemas.MarketplaceItem)
def create_marketplace_item(
    item: schemas.MarketplaceItemCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Creates a new marketplace item associated with the logged-in seller."""
    db_item = models.MarketplaceItem(**item.dict(), seller_id=user.id)
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

# ✅ List Marketplace Items (With Filters)
@router.get("/list_marketplace_items", response_model=List[schemas.MarketplaceItem])
def list_marketplace_items(
    skip: int = 0,
    limit: int = 100,
    seller_id: Optional[str] = None,
    condition: Optional[schemas.ItemCondition] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Fetches marketplace items with optional seller and condition filters."""
    query = db.query(models.MarketplaceItem)

    if seller_id:
        query = query.filter(models.MarketplaceItem.seller_id == seller_id)
    if condition:
        query = query.filter(models.MarketplaceItem.condition == condition)

    if search:
        search = search.strip()
        query = query.filter(
            or_(
                func.similarity(models.MarketplaceItem.title, search) > 0.3,
                func.similarity(models.MarketplaceItem.description, search) > 0.3
            )
        ).order_by(func.similarity(models.MarketplaceItem.title, search).desc())

    return query.offset(skip).limit(limit).all()

# ✅ Get Marketplace Item by ID
@router.get("/get_marketplace_item/{item_id}", response_model=schemas.MarketplaceItem)
def get_marketplace_item(
    item_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Retrieves a marketplace item by ID."""
    item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()

    if not item:
        raise HTTPException(status_code=404, detail="Marketplace item not found")

    return item

# ✅ Update Marketplace Item (Only Seller Can Update)
@router.put("/update_marketplace_item/{item_id}", response_model=schemas.MarketplaceItem)
def update_marketplace_item(
    item_id: str,
    item_update: schemas.MarketplaceItemCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows the seller to update their listed marketplace item."""
    db_item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()

    if not db_item:
        raise HTTPException(status_code=404, detail="Marketplace item not found")

    if db_item.seller_id != user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this item")

    for key, value in item_update.dict().items():
        setattr(db_item, key, value)

    db.commit()
    db.refresh(db_item)
    return db_item

# ✅ Mark Item as Sold (Only Seller Can Mark)
@router.put("/mark_item_as_sold/{item_id}", response_model=schemas.MarketplaceItem)
def mark_item_as_sold(
    item_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows the seller to mark an item as sold."""
    item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()

    if not item:
        raise HTTPException(status_code=404, detail="Marketplace item not found")

    if item.seller_id != user.id:
        raise HTTPException(status_code=403, detail="Not authorized to mark this item as sold")

    item.is_sold = True
    db.commit()
    db.refresh(item)
    return item

# ✅ Delete Marketplace Item (Only Seller Can Delete)
@router.delete("/delete_marketplace_item/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_marketplace_item(
    item_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows the seller to delete their marketplace item."""
    item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()

    if not item:
        raise HTTPException(status_code=404, detail="Marketplace item not found")

    if item.seller_id != user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this item")

    db.delete(item)
    db.commit()