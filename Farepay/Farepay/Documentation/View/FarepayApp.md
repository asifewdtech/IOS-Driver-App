# FarepayApp.swift Documentation

## Overview
`FarepayApp.swift` is the main entry point of the `Farepay` application. It sets up the necessary configurations, initializes Firebase and Stripe Terminal, manages app lifecycle events, and handles biometric authentication when the app becomes active.

## Dependencies
This file relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `IQKeyboardManagerSwift` - For managing the keyboard behavior.
- `FirebaseCore` - For Firebase initialization.
- `GoogleSignIn` - For Google authentication.
- `StripeTerminal` - For handling Stripe Terminal transactions.

---

## Properties

### **App Lifecycle & Environment**
- `@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate`  
  - Adapts `AppDelegate` to manage application lifecycle events.

- `@Environment(\.scenePhase) var scenePhase`  
  - Monitors changes in the app’s scene phase (active, inactive, background).

### **UI State**
- `@State private var showAuthenticationView = false`  
  - Determines whether to show the authentication view.

- `@ObservedObject private var currencyManager = CurrencyManager(amount: 0)`  
  - Manages currency-related operations.

- `@State private var showContentView = false`  
  - Controls whether to show the main content view.

---

## Views

### `body`
The main application scene:
- Uses `WindowGroup` to create a SwiftUI app window.
- Displays the `SplashView` as the initial screen.
- Monitors `scenePhase` changes to handle app state transitions.

### Scene Phase Handling
- When the app becomes **active**, it:
  - Checks `callFaceID` in `UserDefaults` to determine if Face ID authentication should be triggered.
  - Posts a notification `"appDidBecomeActive"` to notify relevant parts of the app.
  - Removes `callFaceID` from `UserDefaults`.

- When the app enters **background**, it:
  - Sets `callFaceID` in `UserDefaults` to trigger authentication when the app is reopened.

- When the app is **inactive**, it logs the state.

---

## `AppDelegate`
### Purpose:
- Configures Firebase, Stripe Terminal, and `IQKeyboardManagerSwift` during app launch.

### `application(_:didFinishLaunchingWithOptions:)`
- **Initializes Firebase** using `FirebaseApp.configure()`.
- **Sets Stripe Terminal Token Provider** using `Terminal.setTokenProvider(APIClient.shared)`.
- **Enables `IQKeyboardManagerSwift`** to enhance text input experience.

---

## `makeConnection()`
### Purpose:
- Establishes a connection with a backend server to retrieve a Stripe connection token.

### Steps:
1. Creates a `URLSessionConfiguration` and a `URLSession` instance.
2. Sends a `POST` request to the backend API.
3. Parses the JSON response to extract the `"secret"` token.
4. Prints the token if successful or logs an error.

---

## Summary
`FarepayApp.swift` serves as the main entry point of the app, setting up Firebase, Stripe, and keyboard management. It also listens for app lifecycle changes to trigger biometric authentication when needed.


