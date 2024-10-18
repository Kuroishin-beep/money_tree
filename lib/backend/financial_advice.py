from fastapi import FastAPI
from pydantic import BaseModel
from decision_tree_model import DecisionTreeFinancialAdvice
from time_series_model import TimeSeriesForecast
from preprocess_data import preprocess_user_input
import pandas as pd

app = FastAPI()


class UserInput(BaseModel):
    monthly_income: float
    total_weekly_expenses: float
    expenses: list


@app.post('/financial_advice')
def get_financial_advice(user_input: UserInput):
    # Preprocess the user input
    user_input_data = preprocess_user_input(user_input.dict())

    # Load reference data from Firestore or another source
    reference_data = pd.read_csv('reference_data.csv')  # Load your reference data

    # Decision Tree
    dt_advice = DecisionTreeFinancialAdvice(reference_data)
    dt_advice.train_model()  # Train the model if not trained already
    advice = dt_advice.predict_advice(user_input_data)

    # Time Series Forecasting
    ts_model = TimeSeriesForecast(reference_data)
    ts_model.train_model()  # Train the model if not trained already
    forecast = ts_model.forecast(steps=5)

    return {'advice': advice, 'forecasted_expenses': forecast.tolist()}
