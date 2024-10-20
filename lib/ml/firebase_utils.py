import os

import firebase_admin
from firebase_admin import credentials, firestore


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


def get_income_brackets():
    """
    Fetch income brackets from Firestore.

    Returns:
        tuple: A tuple containing the documents from low, middle, and high income brackets.
    """
    db = firestore.client()  # Initialize Firestore client here

    # Fetch documents from the respective collections
    low = db.collection("low_income_bracket").get()
    middle = db.collection("middle_income_bracket").get()
    high = db.collection("high_income_bracket").get()

    # Convert the document snapshots to a dictionary format
    low_data = [doc.to_dict() for doc in low]
    middle_data = [doc.to_dict() for doc in middle]
    high_data = [doc.to_dict() for doc in high]

    return low_data, middle_data, high_data
