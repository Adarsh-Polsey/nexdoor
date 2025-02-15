from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional
from routers.auth import get_current_user
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Create a New Product (Only Business Owners)
@router.post("/create_product", response_model=schemas.Product)
def create_product(
    product: schemas.ProductCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Creates a product under the logged-in user's business."""
    # Ensure user owns the business before adding a product
    business = db.query(models.Business).filter(models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to create products")

    db_product = models.Product(**product.dict(), business_id=business.id)
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product

# ✅ List Products (With Filters)
@router.get("/list_products", response_model=List[schemas.Product])
def list_products(
    skip: int = 0,
    limit: int = 100,
    business_id: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Fetches products with optional business and search filters."""
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

    return query.offset(skip).limit(limit).all()

# ✅ Get Product by ID
@router.get("/get_product/{product_id}", response_model=schemas.Product)
def get_product(
    product_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Retrieves a product by its ID."""
    product = db.query(models.Product).filter(models.Product.id == product_id).first()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    return product

# ✅ Update Product (Only Business Owners)
@router.put("/update_product/{product_id}", response_model=schemas.Product)
def update_product(
    product_id: str,
    product_update: schemas.ProductCreate,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows business owners to update their products."""
    db_product = db.query(models.Product).filter(models.Product.id == product_id).first()

    if not db_product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Ensure the user owns the business that created the product
    business = db.query(models.Business).filter(models.Business.id == db_product.business_id, models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to update this product")

    for key, value in product_update.dict().items():
        setattr(db_product, key, value)

    db.commit()
    db.refresh(db_product)
    return db_product

# ✅ Update Product Stock (Only Business Owners)
@router.put("/update_product_stock/{product_id}", response_model=schemas.Product)
def update_product_stock(
    product_id: str,
    stock: int,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows business owners to update product stock."""
    product = db.query(models.Product).filter(models.Product.id == product_id).first()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Ensure the user owns the business that created the product
    business = db.query(models.Business).filter(models.Business.id == product.business_id, models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to update stock")

    product.stock = stock
    db.commit()
    db.refresh(product)
    return product

# ✅ Delete Product (Only Business Owners)
@router.delete("/delete_product/{product_id}", status_code=204)
def delete_product(
    product_id: str,
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """Allows business owners to delete their products."""
    product = db.query(models.Product).filter(models.Product.id == product_id).first()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Ensure the user owns the business that created the product
    business = db.query(models.Business).filter(models.Business.id == product.business_id, models.Business.owner_id == user.id).first()
    if not business:
        raise HTTPException(status_code=403, detail="Not authorized to delete this product")

    db.delete(product)
    db.commit()