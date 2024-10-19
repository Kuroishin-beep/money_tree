import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
import joblib
import os

MODEL_PATH = 'financial_advice_model.joblib'


def train_decision_tree():
    try:
        df = pd.read_csv(r'D:\Github\Project\money_tree\lib\ml\expenses.csv')

        df['Balance'].fillna(0, inplace=True)
        df['Category'] = df['Category'].str.lower().str.strip()
        df['Date'] = pd.to_datetime(df['Date'], format='%m/%d/%Y')
        df['DayOfWeek'] = df['Date'].dt.day_name()
        df['Month'] = df['Date'].dt.month_name()
        df['Item'] = df['Item'].str.replace(r'[^\w\s]', '', regex=True).str.strip()

        df['TotalSpending'] = df.groupby('Category')['Amount'].transform('sum')
        df['AverageDailyBalance'] = df.groupby('Date')['Balance'].transform('mean')

        X = df[['Amount', 'Balance', 'TotalSpending', 'AverageDailyBalance']]
        categorical_features = ['Category', 'DayOfWeek', 'Month']
        X_categorical = df[categorical_features]

        df['advice_score'] = (df['Balance'] / df['TotalSpending']).clip(0, 1)
        y = df['advice_score']

        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        X_cat_train, X_cat_test = train_test_split(X_categorical, test_size=0.2, random_state=42)

        preprocessor = ColumnTransformer(
            transformers=[
                ('num', 'passthrough',
                 ['Amount', 'Balance', 'TotalSpending', 'AverageDailyBalance']),
                ('cat', OneHotEncoder(drop='first', sparse=False), categorical_features)
            ])

        model = Pipeline([
            ('preprocessor', preprocessor),
            ('regressor', DecisionTreeRegressor(random_state=42))
        ])

        model.fit(X_train.join(X_cat_train), y_train)
        y_pred = model.predict(X_test.join(X_cat_test))
        mse = mean_squared_error(y_test, y_pred)
        print(f"Model MSE: {mse}")

        joblib.dump(model, MODEL_PATH)
        print("Model trained and saved successfully.")
    except Exception as e:
        print(f"Error training model: {e}")


def predict_financial_advice(income, expenses, budget, savings):
    if not os.path.exists(MODEL_PATH):
        train_decision_tree()

    model = joblib.load(MODEL_PATH)
    data = pd.DataFrame({
        'Amount': [expenses],
        'Balance': [income - expenses],
        'TotalSpending': [expenses],
        'AverageDailyBalance': [income - expenses],
        'Category': ['custom'],
        'DayOfWeek': ['Monday'],
        'Month': ['January']
    })

    prediction = model.predict(data)
    return prediction[0]


def create_financial_advice(income, expenses, budget, savings):
    advice = predict_financial_advice(income, expenses, budget, savings)

    if advice < 0.5:
        return "You might want to reduce your spending."
    else:
        return "Your financial status looks good!"
