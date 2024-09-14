Expense Tracker Application Documentation

The Expense Tracker is a Flutter-based mobile application that allows users to manage their expenses efficiently. The app implements the MVVM (Model-View-ViewModel) architecture and uses the Provider package for state management. User preferences and settings, such as personal details, are saved locally using SharedPreferences. Depending on whether the user has completed their profile setup, the app directs them to either the main screen or a user details input screen.

Key Features
User Onboarding:
The app checks if the user has provided their details (such as name) on first launch. If not, it prompts the user to enter these details and stores them locally. This onboarding process only occurs once, streamlining future app launches.
Expense Management:
Users can manage expenses by adding, editing, or deleting entries. These expenses can be categorized and displayed on the home screen. The expense data is managed via a ViewModel that interacts with the UI.
Local Data Storage:
The app uses SharedPreferences to store and retrieve user information such as their name, enabling personalized experiences without requiring a backend or cloud storage.
State Management with Provider:
The Provider package is used to manage the application's state. It ensures that updates to the data (e.g., expense list) are reflected across all relevant screens in real-time.
Architecture
The app follows the MVVM (Model-View-ViewModel) architecture to separate concerns:

**View (UI Layer):**

The UI components are responsible for displaying the app's data and interacting with the user. Key screens include:

HomeScreen: Displays the user's expenses and options for managing them.

UserDetailsView: Prompts the user to enter personal information (e.g., name) during initial setup.

**ViewModel (Business Logic Layer):**

The ExpenseViewModel handles the app's core logic, such as adding and deleting expenses. It communicates between the UI and the underlying data model, ensuring the user interface stays updated with any changes in the data.

**Model (Data Layer):**

The data model represents the structure of the expense entries and user information. This layer is responsible for storing, retrieving, and updating expense data.

