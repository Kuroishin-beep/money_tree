import os
import threading

import firebase_admin
import pandas as pd
from fastapi import FastAPI
from firebase_admin import credentials, firestore
from pydantic import BaseModel

from ml_model import train_decision_tree, create_financial_advice

app = FastAPI()

# Initialize Firebase Admin SDK using environment variables
service_account_info = {
    'type': 'service_account',
    'project_id': os.getenv('FIREBASE_ADMIN_PROJECT_ID', 'moneytree-49dc0'),
    'private_key_id': os.getenv('FIREBASE_ADMIN_PRIVATE_KEY_ID'),
    'private_key': os.getenv('FIREBASE_ADMIN_PRIVATE_KEY').replace('\\n', '\n'),
    'client_email': os.getenv('FIREBASE_ADMIN_CLIENT_EMAIL'),
    'client_id': os.getenv('FIREBASE_ADMIN_CLIENT_ID'),
    'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
    'token_uri': 'https://oauth2.googleapis.com/token',
    'auth_provider_x509_cert_url': os.getenv('FIREBASE_ADMIN_AUTH_PROVIDER_X509_CERT_URL'),
    'client_x509_cert_url': os.getenv('FIREBASE_ADMIN_CLIENT_X509_CERT_URL'),
}

# Initialize the app with the service account
cred = credentials.Certificate(service_account_info)
firebase_admin.initialize_app(cred)

# Initialize Firestore
db = firestore.client()


class Tracker(BaseModel):
    totalCash: float
    totalCard: float
    totalGCash: float
    amount: float
    budgetAmount: float
    savingsAmount: float


@app.post("/financial_predict")
def financial_predict(input_data: Tracker):
    """Predict financial advice based on Tracker instance."""
    total_income = input_data.totalCash + input_data.totalCard + input_data.totalGCash
    advice = create_financial_advice(
        income=total_income,
        expenses=input_data.amount,
        budget=input_data.budgetAmount,
        savings=input_data.savingsAmount
    )
    return {"financial_advice": advice}


@app.on_event("startup")
def startup_event():
    print("Available routes:")
    for route in app.routes:
        print(route)

    # Fetch initial data and train the model if CSV is available
    fetch_data('test@gmail.com')  # Replace with appropriate user email
    train_decision_tree()


def fetch_data(user_email):
    data = {
        'budgets': [],
        'savings': [],
        'income': [],
        'expenses': []
    }

    try:
        print(f"Fetching data for user: {user_email}")

        # Test query to ensure connection
        db.collection('budgets').limit(1).stream()
        print("Test query executed successfully.")

        collections = {
            'budgets': 'budgetAmount',
            'savings': 'savingsAmount',
            'income': 'amount',
            'expenses': 'amount'
        }

        for key, amount_field in collections.items():
            print(f"Fetching {key}...")
            docs = db.collection(key).where('UserEmail', '==', user_email).stream()
            docs_list = list(docs)  # Convert stream to list
            print(f"{key.capitalize()} documents fetched: {len(docs_list)}")

            for doc in docs_list:
                doc_data = doc.to_dict()
                print(f"Processing document: {doc_data}")
                data[key].append({
                    'amount': doc_data.get(amount_field),
                    'total_amount': doc_data.get(f'total{amount_field.capitalize()}', ''),
                    'date': doc_data.get('date')
                })

        save_to_csv(data)

    except Exception as e:
        print(f"Error fetching data: {e}")


def save_to_csv(data, filename='user_budget_data.csv'):
    """Saves the fetched data into a CSV file."""
    if not data or all(len(v) == 0 for v in data.values()):
        print("No data to save. Skipping CSV generation.")
        return

    rows = []
    for key, entries in data.items():
        for entry in entries:
            rows.append(
                [key.capitalize(), entry['amount'], entry.get('total_amount', ''), entry['date']]
            )

    df = pd.DataFrame(rows, columns=['Type', 'Amount', 'Total Amount', 'Date'])

    # Format dates for consistent output
    df['Date'] = pd.to_datetime(df['Date'], errors='coerce').dt.strftime('%Y-%m-%d')

    # Save DataFrame to CSV
    df.to_csv(filename, index=False)
    print(f"CSV file '{filename}' created successfully.")


# Start periodic model training in a separate thread
def start_model_training():
    fetch_data('test@gmail.com')  # Replace with appropriate user email
    train_decision_tree()
    threading.Timer(7 * 24 * 60 * 60, start_model_training).start()


start_model_training()
