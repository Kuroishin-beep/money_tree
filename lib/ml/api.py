import os
import threading
import firebase_admin
import pandas as pd
from fastapi import FastAPI
from firebase_admin import credentials, firestore
from pydantic import BaseModel
from dotenv import load_dotenv
from ml_model import train_decision_tree, create_financial_advice
from datetime import datetime

# Load environment variables from .env file
load_dotenv()

# Initialize FastAPI app
app = FastAPI()

# Initialize Firebase Admin SDK using environment variables
def initialize_firebase():
    private_key = os.getenv("FIREBASE_PRIVATE_KEY").replace('\\n', '\n') if os.getenv("FIREBASE_PRIVATE_KEY") else None
    if not private_key:
        raise ValueError("FIREBASE_PRIVATE_KEY is missing.")

    service_account_info = {
        "type": os.getenv("FIREBASE_TYPE"),
        "project_id": os.getenv("FIREBASE_PROJECT_ID"),
        "private_key_id": os.getenv("FIREBASE_PRIVATE_KEY_ID"),
        "private_key": private_key,
        "client_email": os.getenv("FIREBASE_CLIENT_EMAIL"),
        "client_id": os.getenv("FIREBASE_CLIENT_ID"),
        "auth_uri": os.getenv("FIREBASE_AUTH_URI"),
        "token_uri": os.getenv("FIREBASE_TOKEN_URI"),
        "auth_provider_x509_cert_url": os.getenv("FIREBASE_AUTH_PROVIDER_X509_CERT_URL"),
        "client_x509_cert_url": os.getenv("FIREBASE_CLIENT_X509_CERT_URL"),
    }

    if not firebase_admin._apps:
        cred = credentials.Certificate(service_account_info)
        firebase_admin.initialize_app(cred)
        print("Firebase initialized successfully.")
    else:
        print("Firebase app already initialized.")

initialize_firebase()

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

    # Start periodic tasks
    user_email = 'test@gmail.com'  # Replace with appropriate user email
    threading.Thread(target=periodic_tasks, args=(user_email,), daemon=True).start()

def periodic_tasks(user_email):
    """Fetch data and train the model periodically."""
    while True:
        fetch_data(user_email)
        train_decision_tree()
        time.sleep(3600)  # Run every 1 hour

def fetch_data(user_email):
    data = {
        'budgets': [],
        'savings': [],
        'incomes': [],
        'expenses': []
    }

    try:
        print(f"Fetching data for user: {user_email}")

        # Test query to ensure connection
        db.collection('budgets').limit(1).stream()
        print("Test query executed successfully.")

        collections = {
            'budgets': {
                'amount_field': 'budgetAmount',
                'total_amount_field': 'totalBudgetAmount',
                'additional_fields': ['UserEmail', 'category', 'type']
            },
            'savings': {
                'amount_field': 'savingsAmount',
                'total_amount_field': 'totalSavingsAmount',
                'additional_fields': ['UserEmail', 'type']
            },
            'incomes': {
                'amount_field': 'amount',
                'total_amount_field': 'totalAmount',
                'additional_fields': []
            },
            'expenses': {
                'amount_field': 'amount',
                'total_amount_field': 'totalAmount',
                'additional_fields': []
            }
        }

        for key, fields in collections.items():
            print(f"Fetching {key}...")
            docs = db.collection(key).where('UserEmail', '==', user_email).stream()
            docs_list = list(docs)  # Convert stream to list
            print(f"{key.capitalize()} documents fetched: {len(docs_list)}")

            for doc in docs_list:
                doc_data = doc.to_dict()
                print(f"Processing document: {doc_data}")

                # Extract amount and total_amount
                amount = doc_data.get(fields['amount_field'], 0)
                total_amount = doc_data.get(fields['total_amount_field'], 0)

                # Extract additional fields, if any
                additional_data = {field: doc_data.get(field, '') for field in fields['additional_fields']}

                # Check for date; if not present, set it to now
                date = doc_data.get('date', datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

                # Construct the entry with the specified fields
                entry = {
                    'amount': amount,
                    'total_amount': total_amount,
                    'date': date,
                    **additional_data
                }

                data[key].append(entry)

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
            if key.lower() in ['incomes', 'expenses']:
                row = [
                    key.capitalize(),
                    entry['amount'],
                    '',
                    entry['date']
                ]
            else:
                total_amount = entry.get('total_amount', 0)
                row = [
                    key.capitalize(),
                    entry['amount'],
                    total_amount,
                    entry['date']
                ]
            rows.append(row)

    columns = ['Type', 'Amount', 'Total Amount', 'Date']
    df = pd.DataFrame(rows, columns=columns)

    df['Date'] = pd.to_datetime(df['Date'], errors='coerce', utc=True)
    df['Date'] = df['Date'].dt.strftime('%Y-%m-%d')

    df.to_csv(filename, index=False)
    print(f"CSV file '{filename}' created successfully.")

if __name__ == '__main__':
    import uvicorn
    import time  # Import time for the sleep functionality

    uvicorn.run(app, host="0.0.0.0", port=8000)
