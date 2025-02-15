from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth, businesses, services, bookings, products, marketplace
from database import engine
import models

# ✅ Ensure tables are created at startup
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="NexDoor API", version="1.0.0")

# ✅ CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Include routers with versioning
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(businesses.router, prefix="/api/v1/businesses", tags=["Businesses"])
app.include_router(services.router, prefix="/api/v1/services", tags=["Services"])
app.include_router(bookings.router, prefix="/api/v1/bookings", tags=["Bookings"])
app.include_router(products.router, prefix="/api/v1/products", tags=["Products"])
app.include_router(marketplace.router, prefix="/api/v1/marketplace", tags=["Marketplace"])

# ✅ Root API response
@app.get("/")
def read_root():
    return {"message": "Welcome to NexDoor API!"}