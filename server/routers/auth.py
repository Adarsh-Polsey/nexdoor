from fastapi import APIRouter, Depends, HTTPException, Header, status
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from passlib.context import CryptContext
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Password Hashing Setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# ✅ Dependency to Get Current User from Headers
@router.post("/get_current_user", status_code=200)
def get_current_user(user_id: str = Header(None), db: Session = Depends(get_db)):
    """Fetch the current user based on `user_id` in request headers."""
    if not user_id:
        raise HTTPException(status_code=401, detail="Missing user ID in headers")

    user = db.query(models.User).filter(models.User.uid == user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="Invalid user ID")
    return user

# ✅ Signup Route (Creates a New User)
@router.post("/signup", status_code=201)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Check if the email is already in use
    if db.query(models.User).filter(models.User.email == user.email).first():
        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )
    # Create a new user instance
    new_user = models.User(
        uid=user.uid,
        email=user.email,
        full_name=user.full_name,
        phone_number=user.phone_number,
        location=user.location,
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return JSONResponse(status_code=201, content={"message": "User registered successfully"})

# # ✅ Login Route (Verifies Credentials)
# @router.post("/login", status_code=200_OK)
# def login_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
#     """Verifies user credentials and returns user ID upon successful authentication."""
    
#     db_user = db.query(models.User).filter(models.User.email == user.email).first()
    
#     if not db_user or not verify_password(user.password, db_user.hashed_password):
#         raise HTTPException(status_code=401, detail="Incorrect email or password")

#     return {"user_id": str(db_user.id), "message": "Login successful"}