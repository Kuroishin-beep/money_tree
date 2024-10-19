from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from lib.ml.main import api_router
from ml_model import train_decision_tree, create_financial_advice

app = FastAPI()


class InputData(BaseModel):
    income: float
    expenses: float
    budget: float
    savings: float


@app.post("/financial_predict")
def financial_predict(input_data: InputData):
    """
    Predict financial advice based on user input.
    """
    advice = create_financial_advice(input_data.income, input_data.expenses, input_data.budget,
                                     input_data.savings)
    return {"financial_advice": advice}


@api_router.post("/train_model")
def train_model():
    """
    Endpoint to trigger model training.

    Returns:
        dict: A confirmation message after training the model.
    """
    try:
        train_decision_tree()  # Call the training function
        return {"message": "Model training started successfully."}
    except Exception as e:
        return {"error": str(e)}
# Include API router


app.include_router(api_router)
