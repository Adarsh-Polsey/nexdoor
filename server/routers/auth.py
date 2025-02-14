from fastapi import APIRouter, Depends, HTTPException, Header, status
from sqlalchemy.orm import Session
from passlib.context import CryptContext
import models, schemas
from database import get_db

router = APIRouter()

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)


def get_current_user(user_id: str = Header(None), db: Session = Depends(get_db)):
    if not user_id:
        raise HTTPException(status_code=401, detail="Missing user ID in headers")

    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="Invalid user ID")

    return user

# ✅ Signup Route (Creates a New User)
@router.post("/signup", response_model=schemas.User)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Check if the email is already registered
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    hashed_password = get_password_hash(user.password)

    db_user = models.User(
        email=user.email,
        full_name=user.full_name,
        phone_number=user.phone_number,
        location=user.location,
        hashed_password=hashed_password
    )

    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return db_user 

# ✅ Login Route (Verifies Credentials)
@router.post("/login")
def login_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    
    if not db_user or not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=401, detail="Incorrect email or password")

    # ✅ Return only the user ID instead of a token
    return {"user_id": str(db_user.id), "message": "Login successful"}