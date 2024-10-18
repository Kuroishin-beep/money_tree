import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
import joblib

def load_data():
    df = pd.read_csv('data/historical_data.csv')  # Replace with your time series data
    return df

def train_model():
    df = load_data()

    # Assume the 'target' is the column we want to predict and others are features
    df['forecasted_income'] = df['income'].shift(-1)  # Example of adding forecasted data
    df.dropna(inplace=True)  # Remove any NaN values

    X = df.drop('target', axis=1)
    y = df['target']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    model = DecisionTreeClassifier()
    model.fit(X_train, y_train)

    joblib.dump(model, 'model/your_model.joblib')

if __name__ == "__main__":
    train_model()
