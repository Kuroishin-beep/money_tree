from fastapi import FastAPI
from api import api_router
from firebase_utils import initialize_firebase

app = FastAPI()

# Initialize Firebase
initialize_firebase()

# Include API router
app.include_router(api_router)