import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
import warnings
import os
from datetime import datetime

# Suppress Firestore warnings
warnings.filterwarnings("ignore", category=UserWarning, module='google.cloud.firestore_v1.base_collection')

# Initialize Firebase Admin SDK
SERVICE_ACCOUNT_PATH = os.getenv(
    'SERVICE_ACCOUNT_PATH',
    "D:\\Github\\Project\\money_tree\\moneytree-49dc0-firebase-adminsdk-v75eb-4901091a46.json"
)
cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.client()


def fetch_data(user_email):
    """Fetch incomes, expenses, budgets, and savings data from Firestore."""
    data = {'incomes': [], 'expenses': [], 'budgets': [], 'savings': []}

    try:
        print(f"Fetching data for user: {user_email}")

        collections = ['incomes', 'expenses', 'budgets', 'savings']

        for collection_name in collections:
            print(f"Fetching {collection_name}...")
            docs = db.collection(collection_name).where('UserEmail', '==', user_email).stream()
            docs_list = list(docs)

            if not docs_list:
                print(f"No documents found in {collection_name}.")
                continue

            print(f"{collection_name.capitalize()} documents fetched: {len(docs_list)}")

            # Process each document
            for doc in docs_list:
                doc_data = doc.to_dict()
                print(f"Processing document: {doc_data}")

                # Store document data in the appropriate format
                data[collection_name].append({
                    'account': doc_data.get('account'),
                    'amount': doc_data.get('amount'),
                    'category': doc_data.get('category'),
                    'name': doc_data.get('name'),
                    'date': doc_data.get('date'),
                })

        return data

    except Exception as e:
        print(f"Error fetching data: {e}")
        return None


def save_to_csv(data, filename='user_data.csv'):
    """Saves or updates the fetched data into a CSV file."""
    if not data or all(len(v) == 0 for v in data.values()):
        print("No data to save. Skipping CSV generation.")
        return

    # Prepare data as rows
    rows = [
        [
            collection_name.capitalize(),
            entry['account'],
            entry['amount'],
            entry['category'],
            entry['name'],
            entry['date']
        ]
        for collection_name, entries in data.items()
        for entry in entries
    ]

    # Create a DataFrame
    new_df = pd.DataFrame(rows, columns=['Type', 'Account', 'Amount', 'Category', 'Name', 'Date'])

    # Format dates for consistency
    new_df['Date'] = pd.to_datetime(new_df['Date'], errors='coerce').dt.strftime('%Y-%m-%d')

    if os.path.exists(filename):
        # If the file exists, read existing data and merge with new data to avoid duplicates
        existing_df = pd.read_csv(filename)
        combined_df = pd.concat([existing_df, new_df]).drop_duplicates()
        combined_df.to_csv(filename, index=False)
        print(f"CSV file '{filename}' updated with new data.")
    else:
        # Create a new CSV file
        new_df.to_csv(filename, index=False)
        print(f"CSV file '{filename}' created successfully.")


def main():
    """Main function to fetch user data and save it to a CSV file."""
    user_email = os.getenv('USER_EMAIL', 'test@gmail.com')  # Use environment variable or default
    data = fetch_data(user_email)

    if data:
        filename = 'user_data.csv'
        save_to_csv(data, filename)


if __name__ == '__main__':
    main()
