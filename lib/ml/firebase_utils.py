import firebase_admin
from firebase_admin import credentials, firestore


def initialize_firebase():
    """
    Initialize Firebase Admin SDK.
    """
    # Check if the default app is already initialized
    if not firebase_admin._apps:
        # Initialize Firebase Admin SDK
        cred = credentials.Certificate(
            "D:\\Github\\Project\\money_tree\\serviceAccountKey_moneytree.json")
        firebase_admin.initialize_app(cred)
        print("Firebase initialized successfully.")
    else:
        print("Firebase has already been initialized.")


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
