import logging
import os
from datetime import datetime, timedelta

import firebase_admin
import pandas as pd
from dotenv import load_dotenv
from fastapi import FastAPI
from firebase_admin import credentials, firestore, auth
from starlette.responses import JSONResponse

from ml_model import train_decision_tree, create_financial_advice

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


def list_recent_users(hours=24):
    """Fetch users who have logged in within the last `hours` hours."""
    recent_users = []
    try:
        time_threshold = datetime.now() - timedelta(hours=hours)
        page = auth.list_users()

        while page:
            for user in page.users:
                # Check if the user has logged in recently
                last_sign_in = user.user_metadata.last_sign_in_timestamp
                if last_sign_in:
                    last_sign_in_time = datetime.fromtimestamp(last_sign_in / 1000.0)

                    # Log for debugging
                    logging.info(f"User: {user.email}, Last Sign-In: {last_sign_in_time}")

                    if last_sign_in_time >= time_threshold:
                        recent_users.append(user)

            page = page.get_next_page()

        logging.info(f"Found {len(recent_users)} recently active users.")
    except Exception as e:
        logging.error(f"Error fetching recent users: {e}")

    return recent_users


def fetch_data(user_email):
    """Fetch data from Firestore for a given user and save to CSV."""
    data = {'budgets': [], 'savings': [], 'incomes': [], 'expenses': []}
    try:
        logging.info(f"Fetching data for user: {user_email}")
        collections = {
            'budgets': {'amount_field': 'budgetAmount', 'total_amount_field': 'totalBudgetAmount'},
            'savings': {'amount_field': 'savingsAmount',
                        'total_amount_field': 'totalSavingsAmount'},
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

        # Generate financial advice based on the latest data
        advice = create_financial_advice(
            latest_data['TotalIncome'], latest_data['TotalExpenses'],
            latest_data['TotalBudgets'], latest_data['TotalSavings']
        )

        forecasted_expenses = df[df['Type'] == 'Expenses']['Amount'].tolist()

        logging.info(f"Financial advice: {advice}")
        return advice, forecasted_expenses
    except Exception as e:
        logging.error(f"Error generating financial advice: {e}")
        return None, []


def listen_for_changes(user_email):
    """Listen for updates in the user's Firestore collections."""

    def on_snapshot(col_snapshot, changes, read_time):
        for change in changes:
            if change.type.name in ('ADDED', 'MODIFIED', 'REMOVED'):
                logging.info(f'Document {change.document.id} has changed.')
                fetch_data(user_email)
                process_and_generate_advice()

    collections = ['budgets', 'savings', 'incomes', 'expenses']
    for collection_name in collections:
        collection_ref = db.collection(collection_name).where('UserEmail', '==', user_email)
        collection_ref.on_snapshot(on_snapshot)


@app.get("/financial_advice/{user_email}")
async def get_financial_advice(user_email: str):
    """Endpoint to get the latest financial advice and forecasted expenses."""
    try:
        # Fetch the latest data and generate advice
        fetch_data(user_email)  # Fetch latest data for the user
        advice, forecasted_expenses = process_and_generate_advice()  # Process data and generate advice

        if advice is None:
            return JSONResponse(
                content={"error": "Could not generate financial advice"},
                status_code=500
            )

        return JSONResponse(
            content={
                "financial_advice": advice,
                "forecasted_expenses": forecasted_expenses
            },
            status_code=200
        )
    except Exception as e:
        logging.error(f"Error fetching financial advice: {e}")
        return JSONResponse(
            content={"error": "Could not fetch financial advice"},
            status_code=500
        )


@app.on_event("startup")
def startup_event():
    """Run tasks at startup and set up Firestore listeners."""
    logging.info("FastAPI startup: Routes available.")
    for route in app.routes:
        logging.info(route)

    # Set up real-time listeners for user data changes
    users = list_recent_users()
    for user in users:
        listen_for_changes(user.email)

    logging.info("Firestore listeners set up for data changes.")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8001)
