# ml_model.py
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import joblib
from firebase_utils import firestore


def load_data_from_firestore():
    """Load data from Firestore collections for different income brackets."""
    db = firestore.client()
    low_data = db.collection("low_income_bracket").get()
    middle_data = db.collection("middle_income_bracket").get()
    high_data = db.collection("high_income_bracket").get()

    # Convert Firestore documents to DataFrames
    low_df = pd.DataFrame([doc.to_dict() for doc in low_data])
    middle_df = pd.DataFrame([doc.to_dict() for doc in middle_data])
    high_df = pd.DataFrame([doc.to_dict() for doc in high_data])

    # Combine DataFrames
    combined_df = pd.concat([low_df, middle_df, high_df], ignore_index=True)
    return combined_df


def train_decision_tree():
    """Train a Decision Tree model using data from Firestore."""
    df = load_data_from_firestore()
    features = df[['income', 'expenses', 'budget', 'savings']]
    labels = df['financial_advice']

    # Encode labels
    label_encoder = LabelEncoder()
    labels = label_encoder.fit_transform(labels)

    # Split data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.2,
                                                        random_state=42)

    # Train the Decision Tree model
    model = DecisionTreeClassifier()
    model.fit(X_train, y_train)

    # Save the model and label encoder
    joblib.dump(model, 'decision_tree_model.pkl')
    joblib.dump(label_encoder, 'label_encoder.pkl')

    print("Decision Tree model trained and saved.")


def load_model():
    """Load the trained model and label encoder from disk."""
    model = joblib.load('decision_tree_model.pkl')
    label_encoder = joblib.load('label_encoder.pkl')
    return model, label_encoder


def predict_financial_advice(income, expenses, budget, savings):
    """Predict financial advice based on input features."""
    model, label_encoder = load_model()
    features = [[income, expenses, budget, savings]]
    prediction = model.predict(features)
    return label_encoder.inverse_transform(prediction)[0]


def create_financial_advice(income, expenses, budget, savings):
    """Generate financial advice based on income, expenses, budget, and savings."""
    advice = []

    # Calculate savings rate
    savings_rate = (savings / income) * 100 if income > 0 else 0

    # Basic advice based on income and expenses
    if expenses > income:
        advice.append("Your expenses exceed your income. Consider reducing your expenses.")
    elif expenses < income * 0.5:
        advice.append(
            "Great job! Your expenses are well below your income. Consider increasing your savings or investments.")

    # Budgeting advice
    if budget < expenses:
        advice.append(
            "Your budget is less than your expenses. Re-evaluate your budget to ensure it covers your needs.")
    elif budget > expenses * 1.2:
        advice.append(
            "Your budget is significantly higher than your expenses. You might want to adjust it to save more.")

    # Savings advice
    if savings_rate < 10:
        advice.append(
            "Consider increasing your savings rate to at least 10% of your income for better financial security.")
    elif savings_rate >= 20:
        advice.append("Excellent! You're saving more than 20% of your income. Keep it up!")

    # Final advice
    advice.append("Review your financial goals regularly to stay on track.")

    return " ".join(advice)
