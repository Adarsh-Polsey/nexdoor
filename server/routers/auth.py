from fastapi import APIRouter, Depends, HTTPException, Header, status
from sqlalchemy.orm import Session
from passlib.context import CryptContext
import models, schemas
from database import get_db

router = APIRouter()

# ✅ Password Hashing Setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifies a plain text password against the hashed password."""
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    """Returns a hashed version of the given password."""
    return pwd_context.hash(password)

# ✅ Dependency to Get Current User from Headers
def get_current_user(user_id: str = Header(None), db: Session = Depends(get_db)):
    """Fetch the current user based on `user_id` in request headers."""
    if not user_id:
        raise HTTPException(status_code=401, detail="Missing user ID in headers")

    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="Invalid user ID")

    return user

# ✅ Signup Route (Creates a New User)
@router.post("/signup", response_model=schemas.User, status_code=status.HTTP_201_CREATED)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    """Registers a new user, ensuring unique email and securely storing the password."""
    
    # Check if the email is already in use
    if db.query(models.User).filter(models.User.email == user.email).first():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Hash the password before saving
    hashed_password = get_password_hash(user.password)

    # Create a new user instance
    new_user = models.User(
        email=user.email,
        full_name=user.full_name,
        phone_number=user.phone_number,
        location=user.location,
        hashed_password=hashed_password
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user

# ✅ Login Route (Verifies Credentials)
@router.post("/login", status_code=status.HTTP_200_OK)
def login_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    """Verifies user credentials and returns user ID upon successful authentication."""
    
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    
    if not db_user or not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=401, detail="Incorrect email or password")

    return {"user_id": str(db_user.id), "message": "Login successful"}