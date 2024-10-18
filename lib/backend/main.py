from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Dict, List
import random

app = FastAPI()


# Define the data models
class FinancialData(BaseModel):
    incomes: Dict[str, float]  # Map of income sources (CASH, CARD, GCASH)
    expenses: Dict[str, float]  # Map of expense categories


# Function to generate financial advice
def generate_financial_advice(incomes: Dict[str, float], expenses: Dict[str, float]) -> str:
    total_income = sum(incomes.values())
    total_expense = sum(expenses.values())

    # Simple logic to give advice based on income and expenses
    if total_income < total_expense:
        return "Your expenses exceed your income. Consider reducing your spending."
    elif total_income > total_expense:
        return "You are spending less than you earn. Keep it up!"
    else:
        return "Your income and expenses are balanced. Aim to save or invest!"


# Function to forecast expenses
def forecast_expenses(expenses: Dict[str, float]) -> List[float]:
    # Simple forecasting by adding a random percentage increase to each expense category
    forecasted = []
    for amount in expenses.values():
        increase_percentage = random.uniform(0.05, 0.15)  # Random increase between 5% to 15%
        forecasted.append(amount * (1 + increase_percentage))
    return forecasted


@app.post("/financial-advice/")
async def get_financial_advice(data: FinancialData):
    try:
        advice = generate_financial_advice(data.incomes, data.expenses)
        forecasted_expenses = forecast_expenses(data.expenses)

        return {
            "advice": advice,
            "forecasted_expenses": forecasted_expenses
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
