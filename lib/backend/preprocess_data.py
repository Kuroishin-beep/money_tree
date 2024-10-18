import pandas as pd

def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Clean and preprocess the data.
    """
    # Example cleaning steps
    df['monthly_income'] = df['monthly_income'].replace('[\$,]', '', regex=True).astype(float)
    df['total_weekly_expenses'] = df['total_weekly_expenses'].replace('[\$,]', '', regex=True).astype(float)
    df['expenses'] = df['expenses'].astype(float)  # Make sure expenses are floats
    # Add more preprocessing as needed
    return df
