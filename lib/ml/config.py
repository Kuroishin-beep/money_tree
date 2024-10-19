# config.py
import os
import pathlib
from dotenv import load_dotenv
from pydantic import BaseSettings

# Load environment variables from .env file
basedir = pathlib.Path(__file__).parent
load_dotenv(basedir / ".env")


class Settings(BaseSettings):
    app_name: str = "Money Tree"
    env: str = os.getenv("ENV", "development")
    firebase_credentials_path: str = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "path/to/credentials.json")


settings = Settings()