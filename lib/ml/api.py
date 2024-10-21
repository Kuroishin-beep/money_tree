from datetime import datetime
import os
import logging
import time
import pandas as pd
import firebase_admin
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
from dotenv import load_dotenv
from fastapi import FastAPI
from firebase_admin import credentials, firestore, auth
from ml_model import train_decision_tree, predict_financial_advice_from_csv, create_financial_advice

# Load environment variables
load_dotenv()

# Initialize FastAPI app
app = FastAPI()

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# Initialize Firebase Admin SDK
def initialize_firebase():
    private_key = os.getenv("FIREBASE_PRIVATE_KEY").replace('\\n', '\n')
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
        logging.info("Firebase initialized successfully.")

initialize_firebase()

# Initialize Firestore
db = firestore.client()

def list_all_users():
    """Fetch all authenticated users."""
    users = []
    try:
        page = auth.list_users()
        while page:
            users.extend(page.users)
            page = page.get_next_page()
    except Exception as e:
        logging.error(f"Error fetching users: {e}")
    return users

def fetch_data(user_email):
    """Fetch data from Firestore for a given user and save to CSV."""
    data = {'budgets': [], 'savings': [], 'incomes': [], 'expenses': []}
    try:
        logging.info(f"Fetching data for user: {user_email}")
        collections = {
            'budgets': {'amount_field': 'budgetAmount', 'total_amount_field': 'totalBudgetAmount'},
            'savings': {'amount_field': 'savingsAmount', 'total_amount_field': 'totalSavingsAmount'},
            'incomes': {'amount_field': 'amount', 'total_amount_field': 'totalAmount'},
            'expenses': {'amount_field': 'amount', 'total_amount_field': 'totalAmount'}
        }

        for key, fields in collections.items():
            docs = db.collection(key).where('UserEmail', '==', user_email).stream()
            for doc in docs:
                doc_data = doc.to_dict()
                entry = {
                    'amount': doc_data.get(fields['amount_field'], 0),
                    'total_amount': doc_data.get(fields['total_amount_field'], 0),
                    'date': doc_data.get('date', datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
                }
                data[key].append(entry)

        save_to_csv(data)
    except Exception as e:
        logging.error(f"Error fetching data for {user_email}: {e}")

def save_to_csv(data, filename='user_budget_data.csv'):
    """Save fetched data to a CSV file."""
    if not data or all(len(v) == 0 for v in data.values()):
        logging.info("No data to save. Skipping CSV generation.")
        return

    rows = [
        [key.capitalize(), entry['amount'], entry['total_amount'], entry['date']]
        for key, entries in data.items() for entry in entries
    ]

    df = pd.DataFrame(rows, columns=['Type', 'Amount', 'Total Amount', 'Date'])
    df.to_csv(filename, index=False)
    logging.info(f"CSV file '{filename}' created successfully.")

def process_and_generate_advice():
    """Process data and generate financial advice."""
    try:
        df = pd.read_csv('user_budget_data.csv')
        df.fillna(0, inplace=True)
        df['TotalIncome'] = df['Amount'].where(df['Type'] == 'Incomes', 0)
        df['TotalExpenses'] = df['Amount'].where(df['Type'] == 'Expenses', 0)
        df['TotalSavings'] = df['Amount'].where(df['Type'] == 'Savings', 0)
        df['TotalBudgets'] = df['Amount'].where(df['Type'] == 'Budgets', 0)

        latest_data = df.groupby('Date').agg({
            'TotalIncome': 'sum',
            'TotalExpenses': 'sum',
            'TotalSavings': 'sum',
            'TotalBudgets': 'sum'
        }).reset_index().iloc[-1]

        advice = create_financial_advice(
            latest_data['TotalIncome'], latest_data['TotalExpenses'],
            latest_data['TotalBudgets'], latest_data['TotalSavings']
        )
        logging.info(f"Financial advice: {advice}")
    except Exception as e:
        logging.error(f"Error generating financial advice: {e}")

def periodic_tasks(user_email):
    """Fetch data, train the model, and generate financial advice."""
    logging.info("Starting periodic task execution.")
    fetch_data(user_email)
    train_decision_tree()
    process_and_generate_advice()

@app.on_event("startup")
def startup_event():
    """Run tasks at startup and schedule them every hour."""
    logging.info("FastAPI startup: Routes available.")
    for route in app.routes:
        logging.info(route)

    # Execute tasks immediately
    users = list_all_users()
    for user in users:
        periodic_tasks(user.email)

    # Schedule periodic tasks every hour
    scheduler = BackgroundScheduler()
    scheduler.add_job(periodic_tasks, IntervalTrigger(minutes=1), args=[users[0].email])  # Example with one user
    scheduler.start()
    logging.info("Scheduled periodic task to run every 10 minutes.")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
