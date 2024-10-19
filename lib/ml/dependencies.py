# dependencies.py
from fastapi import Header, HTTPException
from typing import Annotated


async def get_token_header(x_token: Annotated[str, Header()]):
    if x_token != "your-secret-token":
        raise HTTPException(status_code=400, detail="X-Token header invalid")


async def get_query_token(token: str):
    if token != "expected-token":
        raise HTTPException(status_code=400, detail="Invalid token provided")