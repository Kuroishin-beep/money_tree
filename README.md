# MoneyTree 🌳

A comprehensive budget and personal finance tracker application. **MoneyTree** is an open-source Flutter project developed as a collaborative effort by a team of 7 people for a university project.

## Features

- **User Authentication**: Secure login and registration using Firebase Auth, with support for Google and Facebook sign-in.
- **Budget Tracking**: Monitor your income and expenses easily.
- **Data Visualizations**: View your financial distribution with intuitive pie charts.
- **Calendar Integration**: Keep track of transactions on a calendar view.
- **Cloud Sync**: All data is securely stored and synced across devices using Firebase Firestore and Cloud Storage.

## Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/) & Dart
- **Backend / BaaS**: [Firebase](https://firebase.google.com/) (Authentication, Cloud Firestore, Cloud Storage)
- **Key Packages**:
  - `pie_chart`: For financial data visualization
  - `table_calendar`: For organizing transactions by date
  - `google_sign_in` & `flutter_facebook_auth`: For social authentication
  - `rxdart`: For reactive programming capabilities

## Getting Started

To get started with the project locally, ensure you have Flutter installed on your machine.

### Prerequisites

- Flutter SDK (>=3.4.4 <4.0.0)
- Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd money_tree
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**
   - Create a project on the [Firebase Console](https://console.firebase.google.com/).
   - Add the necessary Android/iOS configurations to your Firebase project. Ensure `google-services.json` and `GoogleService-Info.plist` are correctly placed.

4. **Run the app:**
   ```bash
   flutter run
   ```

## Contributors

This project was built by a collaborative team of 7 university students.

Julia Abasolo
Sean Almendral
Eisha Alva
Mark Dayrit
Kiara Laxamana
Gabriel Ocampo
Angelica Tadique
