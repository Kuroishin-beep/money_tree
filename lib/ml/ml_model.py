import joblib
import os
import pandas as pd
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.tree import DecisionTreeRegressor
import logging

# Initialize logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

MODEL_PATH = 'financial_advice_model.joblib'


def train_decision_tree():
    try:
        # Load data from the CSV
        df = pd.read_csv('user_budget_data.csv')

        # Validate required columns
        required_columns = ['Amount', 'Type', 'Date']
        if not all(col in df.columns for col in required_columns):
            raise ValueError(f"Missing required columns in CSV: {required_columns}")

        # Clean and preprocess the data
        df.fillna(0, inplace=True)  # Replace NaN values with 0
        df['Date'] = pd.to_datetime(df['Date'], errors='coerce')

        # Separate income, expenses, savings, and budgets
        df['TotalIncome'] = df['Amount'].where(df['Type'] == 'Incomes', 0)
        df['TotalExpenses'] = df['Amount'].where(df['Type'] == 'Expenses', 0)
        df['TotalSavings'] = df['Amount'].where(df['Type'] == 'Savings', 0)
        df['TotalBudgets'] = df['Amount'].where(df['Type'] == 'Budgets', 0)

        # Aggregate data by date
        grouped_data = df.groupby('Date').agg({
            'TotalIncome': 'sum',
            'TotalExpenses': 'sum',
            'TotalSavings': 'sum',
            'TotalBudgets': 'sum'
        }).reset_index()

        # Define features and target variable
        X = grouped_data[['TotalIncome', 'TotalExpenses', 'TotalSavings', 'TotalBudgets']]
        y = (grouped_data['TotalSavings'] / grouped_data['TotalBudgets'].replace(0, 1)).clip(0, 1)

        # Split data into training and testing sets
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

        # Create and fit the model
        model = Pipeline([('regressor', DecisionTreeRegressor(random_state=42))])
        model.fit(X_train, y_train)

        # Evaluate the model
        y_pred = model.predict(X_test)
        mse = mean_squared_error(y_test, y_pred)

        # Check for sufficient test samples to compute R²
        if len(X_test) > 1:
            r2 = r2_score(y_test, y_pred)
            logger.info(f"Model MSE: {mse}, R²: {r2}")
        else:
            logger.warning("Not enough test samples to calculate R².")
            logger.info(f"Model MSE: {mse}")

        # Save the model
        joblib.dump(model, MODEL_PATH)
        logger.info("Model trained and saved successfully.")

    except Exception as e:
        logger.error(f"Error training model: {e}")


def predict_financial_advice_from_csv():
    """Use data from the CSV to test the model prediction."""
    try:
        # Train model if it does not exist
        if not os.path.exists(MODEL_PATH):
            train_decision_tree()

        # Load the trained model
        model = joblib.load(MODEL_PATH)
        df = pd.read_csv('user_budget_data.csv')

        # Clean and preprocess the data
        df.fillna(0, inplace=True)
        df['TotalIncome'] = df['Amount'].where(df['Type'] == 'Incomes', 0)
        df['TotalExpenses'] = df['Amount'].where(df['Type'] == 'Expenses', 0)
        df['TotalSavings'] = df['Amount'].where(df['Type'] == 'Savings', 0)
        df['TotalBudgets'] = df['Amount'].where(df['Type'] == 'Budgets', 0)

        # Aggregate data by date
        grouped_data = df.groupby('Date').agg({
            'TotalIncome': 'sum',
            'TotalExpenses': 'sum',
            'TotalSavings': 'sum',
            'TotalBudgets': 'sum'
        }).reset_index()

        # Check if the dataset is empty
        if grouped_data.empty:
            logger.error("No data available for predictions after aggregation.")
            return None

        # Use the latest data for prediction
        latest_data = grouped_data.iloc[-1]

        # Validate the required keys exist
        required_keys = ['TotalIncome', 'TotalExpenses', 'TotalSavings', 'TotalBudgets']
        if not all(key in latest_data.index for key in required_keys):
            logger.error(f"Missing required keys in latest data: {required_keys}")
            return None

        # Prepare the input for prediction
        data = pd.DataFrame([latest_data[required_keys]])

        # Perform prediction
        prediction = model.predict(data)[0]
        logger.info(f"Predicted financial advice value: {prediction}")

        return prediction

    except Exception as e:
        logger.error(f"Error during prediction: {e}")
        return None


def create_financial_advice(income, expenses, budget, savings):
    advice = []

    # Scenario 1: High income but high expenses, low savings
    if income > expenses and expenses > savings:
        advice.append("Your income is good, but you are spending too much. "
                      "Consider reducing discretionary spending and reviewing your fixed expenses.")

    # Scenario 2: Expenses greater than savings
    if expenses > savings:
        advice.append("Your expenses exceed your savings. It's essential to cut back on non-essential expenses "
                      "and look for ways to increase your income.")

    # Scenario 3: Savings greater than expenses
    if savings > expenses:
        advice.append("Great job! Your savings exceed your expenses. Consider allocating a portion of your savings "
                      "towards investments to grow your wealth.")

    # Scenario 4: Low budget with high income and high expenses
    if budget < expenses and income > expenses:
        advice.append("Your budget is low compared to your expenses. It's advisable to adjust your budget "
                      "to better reflect your spending habits or find ways to reduce expenses.")

    # Scenario 5: Adequate savings but very low budget
    if savings > expenses and budget < expenses:
        advice.append("Your savings are good, but your budget might be too low. Reassess your budget to ensure "
                      "it aligns with your spending patterns.")

    # Scenario 6: High savings and balanced budget
    if savings > expenses and expenses <= budget:
        advice.append("Excellent! Your savings are high, and your expenses are within budget. Keep up the good work "
                      "and consider investing some of your savings for future growth.")

    # Scenario 7: Emergency Fund recommendation
    if savings < 3 * expenses:
        advice.append("Consider building an emergency fund to cover at least 3 months of expenses. This safety net "
                      "can protect you against unforeseen circumstances.")

    # Scenario 8: Income less than expenses
    if income < expenses:
        advice.append("Warning: Your income is less than your expenses. Review your budget and spending immediately. "
                      "Consider finding ways to either reduce your expenses or increase your income.")

    # Scenario 9: Balanced financial status
    if income == expenses and savings == 0:
        advice.append("Your income and expenses are balanced, but you have no savings. Aim to save at least a small percentage "
                      "of your income for future needs.")

    # Scenario 10: Excessive savings with no income growth
    if savings > expenses and income == 0:
        advice.append("While you have significant savings, relying solely on savings without income can be risky. "
                      "Consider ways to generate income.")

    # Fallback advice if no specific scenario matched
    if not advice:
        advice.append("Your financial status looks balanced. Keep monitoring your expenses and savings regularly.")

    # Combine all advice messages
    final_advice = "\n".join(advice)

    return final_advice

