# Personalized-Exam-Preparation-Companion
Personalized Exam Preparation Companion

## Running the Backend

This section guides you through setting up and running the backend server of our project. The backend is built with Node.js and utilizes `.env` files for environment variable management. Please follow the steps below to get started.

### Prerequisites

Before you begin, ensure you have the following installed:
- Node.js (v12.x or higher recommended)
- npm (usually comes with Node.js)

### Setup

1. **Clone the Repository**

   First, clone the project repository to your local machine using Git:
   ```bash
   git clone https://github.com/birehan/Personalized-Exam-Preparation-Companion.git
   cd Personalized-Exam-Preparation-Companion/backend
   ```

2. **Install Dependencies**

   Inside the `backend` directory, install the project dependencies by running:
   ```bash
   npm install
   ```

3. **Configure Environment Variables**

   The backend requires certain environment variables to run correctly. These variables are stored in a `.env` file within the `backend` directory. You'll find a `.env.example` file in the repository which outlines the required variables.

   - Copy the `.env.example` file to a new file named `.env`:
     ```bash
     cp .env.example .env
     ```
   - Open the `.env` file and fill in the necessary information for each variable. These might include database URLs, secret keys, API keys, etc.

### Running the Server

After completing the setup steps, you can start the backend server with:

```bash
npx nodemon
```

This command will launch the Node.js application on a default port, usually defined in your `.env` file (e.g., `PORT=3000`). You can access the backend services by navigating to `http://localhost:3000` in your web browser or using tools like Postman to make requests.


## Running the Flutter Application

This section provides instructions on how to set up and run the Flutter application located in the `flutter` folder of this repository. Follow these steps to get the application running on your development machine.

### Prerequisites

Ensure you have the following installed before proceeding:
- Flutter SDK (Ensure it's compatible with the version used in the project. See [Flutter installation guide](https://flutter.dev/docs/get-started/install))
- An IDE that supports Flutter development (e.g., Android Studio, Visual Studio Code)
- For Android: Android SDK and platform tools installed through Android Studio
- For iOS: Xcode installed (macOS only)

### Setup

1. **Clone the Repository**

   If you haven't already, clone the project repository to your local machine:
   ```bash
   git clone https://github.com/birehan/Personalized-Exam-Preparation-Companion.git
   ```

2. **Navigate to the Flutter Directory**

   Change into the `flutter` directory within the cloned repository:
   ```bash
   cd Personalized-Exam-Preparation-Companion/mobile
   ```

3. **Get Dependencies**

   Run the following command to fetch the project's dependencies:
   ```bash
   flutter pub get
   ```

4. **Set Up Your Environment**

   Ensure your development environment is set up according to the needs of your target platform (iOS/Android/web). This may involve setting up virtual devices in Android Studio, configuring an iOS simulator in Xcode, or setting up your web development environment.

### Running the App

- **On Android/iOS:**

  Connect a physical device via USB or set up a simulator/emulator, then run:
  ```bash
  flutter run
  ```
  This command will compile the application and install it on the connected device or emulator/simulator.

- **On Web:**

  To run the app in a web browser, ensure you have enabled web support in your Flutter SDK and then execute:
  ```bash
  flutter run -d chrome
  ```
  This will launch the application in Chrome. You can replace `chrome` with another browser if needed, depending on your Flutter SDK version and support.