from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

@router.post("/create_product/")
def create_product(product: schemas.ProductCreate, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    db_product = models.Product(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product

@router.get("/list_products")
def list_products(
    skip: int = 0,
    limit: int = 100,
    business_id: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    query = db.query(models.Product)
    
    if business_id:
        query = query.filter(models.Product.business_id == business_id)
    
    if search:
        search = search.strip()
        query = query.filter(
            or_(
                func.similarity(models.Product.name, search) > 0.3,
                func.similarity(models.Product.description, search) > 0.3
            )
        ).order_by(func.similarity(models.Product.name, search).desc())
    
    products = query.offset(skip).limit(limit).all()
    return products

@router.get("/get_product/{product_id}")
def get_product(product_id: str, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

@router.post("/update_product/{product_id}")
def update_product(
    product_id: str,
    product: schemas.ProductCreate,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    db_product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    for key, value in product.dict().items():
        setattr(db_product, key, value)
    
    db.commit()
    db.refresh(db_product)
    return db_product

@router.post("/update_product_stock/{product_id}/{stock}")
def update_product_stock(
    product_id: str,
    stock: int,
    db: Session = Depends(get_db), user: models.User = Depends(get_current_user)
):
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    product.stock = stock
    db.commit()
    db.refresh(product)
    return product

@router.post("/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_product(product_id: str, db: Session = Depends(get_db), user: models.User = Depends(get_current_user)):
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    db.delete(product)
    db.commit()
    return None