import pandas as pd
from firebase_admin import firestore

db = firestore.client()

async def get_reference_data() -> pd.DataFrame:
    """
    Retrieve financial data from Firestore and preprocess it.
    """
    financial_data_ref = db.collection('financial_data')
    docs = financial_data_ref.stream()

    records = []
    for doc in docs:
        record = doc.to_dict()
        record['monthly_income'] = float(record['monthly_income'].replace('PHP ', '').replace(',', ''))
        record['total_weekly_expenses'] = float(record['total_weekly_expenses'].replace('PHP ', '').replace(',', ''))
        record['expenses'] = sum(day['total_for_day'] for day in record['expenses'])
        records.append(record)

    df = pd.DataFrame(records)
    return clean_data(df)  # Make sure clean_data is defined as in previous examples
