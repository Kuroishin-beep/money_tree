import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import joblib


class TimeSeriesForecast:
    def __init__(self, historical_data):
        self.model_fit = None
        self.historical_data = historical_data

    def train_model(self):
        # Train ARIMA model on historical expenses
        model = ARIMA(self.historical_data['expenses'], order=(5, 1, 0))
        self.model_fit = model.fit()
        joblib.dump(self.model_fit, 'time_series_model.joblib')

    def forecast(self, steps=5):
        # Forecast future expenses
        forecast = self.model_fit.forecast(steps=steps)
        return forecast
