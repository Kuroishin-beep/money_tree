from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
import joblib


class DecisionTreeFinancialAdvice:
    def __init__(self, reference_data):
        self.reference_data = reference_data  # Load your reference data here
        self.model = DecisionTreeClassifier()

    def train_model(self):
        # Assuming reference_data is a DataFrame with input features and labels
        X = self.reference_data[['monthly_income', 'total_weekly_expenses']]
        y = self.reference_data['financial_advice']  # The label you want to predict

        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
        self.model.fit(X_train, y_train)
        joblib.dump(self.model, 'decision_tree_model.joblib')

    def predict_advice(self, user_input):
        # Use the trained model to make predictions
        input_data = [[user_input['monthly_income'], user_input['total_weekly_expenses']]]
        advice = self.model.predict(input_data)
        return advice[0]  # Return the advice
