from datetime import datetime, timedelta
import random
import logging
import csv
import pandas as pd
from fastapi import FastAPI
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
from ml_model import train_decision_tree, create_financial_advice  # Import your ML functions

# Initialize FastAPI app
app = FastAPI()

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# Constants for generating random data
TYPES = ['Budgets', 'Savings', 'Incomes', 'Expenses']
DATE_FORMAT = "%Y-%m-%d %H:%M:%S"


def generate_random_data(num_entries=50):
    """Generate random financial data."""
    data = []
    for _ in range(num_entries):
        entry_type = random.choice(TYPES)
        amount = round(random.uniform(10, 50000), 2)
        total_amount = round(random.uniform(0, 200000), 2)
        random_date = datetime.now() - timedelta(days=random.randint(0, 30))
        formatted_date = random_date.strftime(DATE_FORMAT)

        data.append([entry_type, amount, total_amount, formatted_date])
    return data


def save_to_csv(data, filename='user_data_test.csv'):
    """Save generated data to a CSV file."""
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Type', 'Amount', 'Total Amount', 'Date'])  # Header row
        writer.writerows(data)
    logging.info(f"CSV file '{filename}' created successfully with {len(data)} entries.")


def process_and_generate_advice():
    """Process data and generate financial advice."""
    try:
        df = pd.read_csv('user_data_test.csv')  # Use the new CSV filename
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

        # Generate financial advice using the create_financial_advice function
        advice = create_financial_advice(
            latest_data['TotalIncome'],
            latest_data['TotalExpenses'],
            latest_data['TotalBudgets'],
            latest_data['TotalSavings']
        )

        logging.info(f"Financial advice: {advice}")
    except Exception as e:
        logging.error(f"Error generating financial advice: {e}")


def periodic_task():
    """Generate random data, save it to CSV, train the model, and process for financial advice."""
    logging.info("Starting periodic task execution.")
    data = generate_random_data()
    save_to_csv(data)

    # Train the decision tree model
    train_decision_tree()

    # Process data to generate financial advice
    process_and_generate_advice()


@app.on_event("startup")
def startup_event():
    """Run tasks at startup and schedule them every hour."""
    logging.info("FastAPI startup: Routes available.")

    # Execute task immediately
    periodic_task()

    # Schedule periodic tasks every hour
    scheduler = BackgroundScheduler()
    scheduler.add_job(periodic_task, IntervalTrigger(minutes=1))
    scheduler.start()
    logging.info("Scheduled task to run every minute.")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
