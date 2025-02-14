from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
import models, schemas
from database import get_db

router = APIRouter()

@router.post("/create_marketplace_item")
def create_marketplace_item(item: schemas.MarketplaceItemCreate, db: Session = Depends(get_db)):
    db_item = models.MarketplaceItem(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@router.get("/list_marketplace_items")
def list_marketplace_items(
    skip: int = 0,
    limit: int = 100,
    seller_id: Optional[str] = None,
    condition: Optional[schemas.ItemCondition] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
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
    
    items = query.offset(skip).limit(limit).all()
    return items

@router.get("/get_marketplace_item/{item_id}")
def get_marketplace_item(item_id: str, db: Session = Depends(get_db)):
    item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()
    if item is None:
        raise HTTPException(status_code=404, detail="Marketplace item not found")
    return item

@router.post("/update_marketplace_item/{item_id}")
def update_marketplace_item(
    item_id: str,
    item: schemas.MarketplaceItemCreate,
    db: Session = Depends(get_db)
):
    db_item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()
    if db_item is None:
        raise HTTPException(status_code=404, detail="Marketplace item not found")
    
    for key, value in item.dict().items():
        setattr(db_item, key, value)
    
    db.commit()
    db.refresh(db_item)
    return db_item

@router.post("/mark_item_as_sold/{item_id}")
def mark_item_as_sold(
    item_id: str,
    db: Session = Depends(get_db)
):
    item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()
    if item is None:
        raise HTTPException(status_code=404, detail="Marketplace item not found")
    
    item.is_sold = True
    db.commit()
    db.refresh(item)
    return item

@router.delete("/delete_marketplace_item/{item_id}")
def delete_marketplace_item(item_id: str, db: Session = Depends(get_db)):
    item = db.query(models.MarketplaceItem).filter(models.MarketplaceItem.id == item_id).first()
    if item is None:
        raise HTTPException(status_code=404, detail="Marketplace item not found")
    
    db.delete(item)
    db.commit()
    return None