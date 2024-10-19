from fastapi import FastAPI, APIRouter
from pydantic import BaseModel
from ml_model import predict_financial_advice, create_financial_advice
from firebase_utils import get_income_brackets
import firebase_admin
from firebase_admin import credentials


# Initialize Firebase Admin SDK
def initialize_firebase():
    cred = credentials.Certificate(
        "D:\\Github\\Project\\money_tree\\serviceAccountKey_moneytree.json")
    if not firebase_admin._apps:
        firebase_admin.initialize_app(cred)
        print("Firebase initialized successfully.")
    else:
        print("Firebase app already initialized.")


# Call the function to initialize Firebase
initialize_firebase()

# Create FastAPI app and router
app = FastAPI()
api_router = APIRouter()


class InputData(BaseModel):
    income: float
    expenses: float
    budget: float
    savings: float


@api_router.get("/predict")
async def predict():
    """
    A simple prediction endpoint that provides a message.
    """
    return {"message": "This is a prediction endpoint"}


@api_router.post("/financial_predict")
def financial_predict(input_data: InputData):
    """
    Predict financial advice based on user input.

    Args:
        input_data (InputData): User input for financial prediction.

    Returns:
        dict: Financial advice based on the input data.
    """
    advice = predict_financial_advice(input_data.income, input_data.expenses, input_data.budget,
                                      input_data.savings)
    return {"financial_advice": advice}


@api_router.post("/create_advice")
def create_advice(input_data: InputData):
    """
    Create financial advice based on user input.

    Args:
        input_data (InputData): User input for creating financial advice.

    Returns:
        dict: Created financial advice based on the input data.
    """
    advice = create_financial_advice(input_data.income, input_data.expenses, input_data.budget,
                                     input_data.savings)
    return {"financial_advice": advice}


# Include API router
app.include_router(api_router)
