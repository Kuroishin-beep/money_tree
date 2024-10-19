# router.py
from fastapi import APIRouter, Depends
from dependencies import get_token_header

router = APIRouter()


@router.get("/")
async def hello():
    return {"msg": "Hello World!"}


@router.get("/userid")
async def get_userid(user: dict = Depends(get_token_header)):
    return {"id": user["uid"]}  # Ensure user dictionary is passed correctly