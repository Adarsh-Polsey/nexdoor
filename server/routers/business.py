from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from utils.database import SessionLocal
from services.auth import get_current_user
from schemas.business import BusinessCreate, BusinessEdit
router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

@router.post("/business_signup", status_code=status.HTTP_201_CREATED)
async def business_signup(business: BusinessCreate, db: AsyncSession = Depends(SessionLocal)):
    # Implement business signup logic
    return {"message": "Business created successfully"}

@router.get("/all_businesses", dependencies=[Depends(get_current_user)])
async def get_all_businesses(db: AsyncSession = Depends(SessionLocal)):
    # Implement logic to get all businesses
    return {"message": "List of all businesses"}

@router.get("/business/{business_id}", dependencies=[Depends(get_current_user)])
async def get_business(business_id: int, db: AsyncSession = Depends(SessionLocal)):
    # Implement logic to get a specific business
    return {"message": f"Details for business {business_id}"}

@router.put("/business/{business_id}/edit", dependencies=[Depends(get_current_user)])
async def edit_business(business_id: int, business: BusinessEdit, db: AsyncSession = Depends(SessionLocal)):
    # Implement logic to edit a business
    return {"message": f"Business {business_id} updated successfully"}

