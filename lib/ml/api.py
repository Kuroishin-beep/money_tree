from datetime import datetime, time

import firebase_admin
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
from fastapi import FastAPI
from firebase_admin import credentials, firestore
from pydantic import BaseModel

from ml_model import *

# Load environment variables from .env file
load_dotenv()

# Initialize FastAPI app
app = FastAPI()

# Load environment variables from .env file
load_dotenv()


# Initialize Firebase Admin SDK using environment variables
def initialize_firebase():

    # Ensure the private key is correctly loaded and formatted
    private_key = os.getenv("FIREBASE_PRIVATE_KEY")
    print(private_key)
    if private_key:
        private_key = private_key.replace('\\n', '\n')  # Correct newlines if necessary
    else:
        raise ValueError("FIREBASE_PRIVATE_KEY is missing.")

    # Construct the service account info dictionary
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

    # Initialize Firebase Admin SDK
    if not firebase_admin._apps:
        cred = credentials.Certificate(service_account_info)
        firebase_admin.initialize_app(cred)
        print("Firebase initialized successfully.")
    else:
        print("Firebase app already initialized.")


# Call the function
initialize_firebase()

# Initialize Firestore
db = firestore.client()

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


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
    logging.info("FastAPI startup event: Routes available")
    for route in app.routes:
        logging.info(route)

    # Start periodic tasks
    scheduler = BackgroundScheduler()
    user_email = 'test2@yahoo.com'  # Replace with appropriate user email
    scheduler.add_job(periodic_tasks, 'interval', hours=1, args=[user_email])
    scheduler.start()
    logging.info("Periodic task for fetching and training started.")

    # Routes logging here...
    logging.info("Starting the training and prediction process.")

    # Train the decision tree model
    train_decision_tree()

    # Generate predictions
    prediction = predict_financial_advice_from_csv()

    if prediction is not None:
        # Run the preprocessing and advice generation
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


def periodic_tasks(user_email):
    """Fetch data and train the model periodically."""
    while True:
        # Train the model and generate predictions
        train_decision_tree()
        prediction = predict_financial_advice_from_csv()

        if prediction is not None:
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
        try:
            # Fetch authenticated users
            users = list_all_users()

            for user in users:
                fetch_data(user.email)

            time.sleep(3600)  # Run every 1 hour
        except Exception as e:
            print(f"Error in periodic tasks: {e}")


def fetch_data(user_email):
    data = {
        'budgets': [],
        'savings': [],
        'incomes': [],
        'expenses': []
    }

    try:
        logging.info(f"Fetching data for user: {user_email}")

        # Test query to ensure connection
        db.collection('budgets').limit(1).stream()
        logging.info("Test query executed successfully.")

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
            logging.info(f"Fetching {key}...")
            docs = db.collection(key).where('UserEmail', '==', user_email).stream()
            docs_list = list(docs)  # Convert stream to list
            logging.info(f"{key.capitalize()} documents fetched: {len(docs_list)}")

            for doc in docs_list:
                doc_data = doc.to_dict()
                logging.info(f"Processing document: {doc_data}")

                # Extract amount and total_amount
                amount = doc_data.get(fields['amount_field'], 0)
                total_amount = doc_data.get(fields['total_amount_field'], 0)

                # Extract additional fields, if any
                additional_data = {field: doc_data.get(field, '') for field in
                                   fields['additional_fields']}

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
        logging.error(f"Error fetching data: {e}")


def list_all_users():
    """Returns a list of all Firebase users."""
    users = []
    try:
        page = auth.list_users()

        while page:
            for user in page.users:
                users.append(user)
            page = page.get_next_page()
    except Exception as e:
        print(f"Error fetching users: {e}")
    return users


def save_to_csv(data, filename='user_budget_data.csv'):
    """Saves the fetched data into a CSV file."""
    if not data or all(len(v) == 0 for v in data.values()):
        logging.info("No data to save. Skipping CSV generation.")
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
    logging.info(f"CSV file '{filename}' created successfully.")


if __name__ == '__main__':
    import uvicorn

    # Start FastAPI server
    uvicorn.run(app, host="0.0.0.0", port=8000)
