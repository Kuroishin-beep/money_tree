from fastapi import FastAPI, APIRouter
from pydantic import BaseModel
from ml_model import predict_financial_advice, create_financial_advice, train_decision_tree
from firebase_utils import get_income_brackets
import firebase_admin
from firebase_admin import credentials
import threading
from firebase_utils import initialize_firebase

# Call the function to initialize Firebase
initialize_firebase()

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

# Define the Tracker model
class Tracker(BaseModel):
    name: str = ''
    category: str = ''
    account: str = ''
    amount: float = 0
    type: str = ''
    date: str = None  # Adjust if you want a datetime object
    icon: int = None
    budgetAmount: float = 0
    savingsAmount: float = 0
    totalBudgetAmount: float = 0
    totalSavingsAmount: float = 0
    balance: float = 0
    totalCash: float = 0
    totalCard: float = 0
    totalGCash: float = 0

@api_router.get("/predict")
async def predict():
    """A simple prediction endpoint that provides a message."""
    return {"message": "This is a prediction endpoint"}

@api_router.post("/financial_predict")
def financial_predict(input_data: Tracker):
    """Predict financial advice based on Tracker instance."""
    advice = predict_financial_advice(
        income=input_data.totalCash + input_data.totalCard + input_data.totalGCash,
        expenses=input_data.amount,
        budget=input_data.budgetAmount,
        savings=input_data.savingsAmount
    )
    return {"financial_advice": advice}

@api_router.post("/create_advice")
def create_advice(input_data: Tracker):
    """Create financial advice based on Tracker instance."""
    low_income, middle_income, high_income = get_income_brackets()

    advice = create_financial_advice(
        income=input_data.totalCash + input_data.totalCard + input_data.totalGCash,
        expenses=input_data.amount,
        budget=input_data.budgetAmount,
        savings=input_data.savingsAmount
    )

    # You can incorporate the income brackets into your advice logic here
    return {
        "financial_advice": advice,
        "low_income_brackets": low_income,
        "middle_income_brackets": middle_income,
        "high_income_brackets": high_income
    }


@api_router.post("/train_model")
def train_model():
    """Endpoint to train the decision tree model."""
    train_decision_tree()
    return {"message": "Model training initiated."}

# Include API router
app.include_router(api_router)

@app.on_event("startup")
def startup_event():
    print("Available routes:")
    for route in app.routes:
        print(route)

# Start periodic model training in a separate thread
def start_model_training():
    train_decision_tree()
    threading.Timer(7 * 24 * 60 * 60, start_model_training).start()  # Run every 7 days

start_model_training()

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
