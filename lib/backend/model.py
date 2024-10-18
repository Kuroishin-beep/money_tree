import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.preprocessing import StandardScaler
import joblib
from preprocess import clean_data
from firestore_data import get_reference_data

async def train_model():
    reference_data = await get_reference_data()

    # Prepare the features and target
    X = reference_data[['monthly_income', 'total_weekly_expenses', 'expenses']]
    y = reference_data['some_target_variable']  # Define your target variable

    # Split the data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Feature scaling
    scaler = StandardScaler()
    X_train = scaler.fit_transform(X_train)
    X_test = scaler.transform(X_test)

    # Train the model
    model = DecisionTreeRegressor()
    model.fit(X_train, y_train)

    # Save the model and scaler
    joblib.dump(model, 'your_model.joblib')
    joblib.dump(scaler, 'scaler.joblib')

    print("Model trained and saved successfully!")
