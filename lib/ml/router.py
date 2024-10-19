import firebase_admin
from firebase_admin import credentials, firestore

firebase_admin.initialize_app()
db = firestore.client()


def get_income_brackets():
    income_brackets_ref = db.collection(u'income_brackets').document(u'brackets')
    income_brackets = income_brackets_ref.get().to_dict()
    return income_brackets
