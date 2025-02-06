# LoginView.swift Documentation

## Overview
`LoginView.swift` is a SwiftUI-based login screen for the Farepay app. It integrates with Firebase Authentication, Google Sign-In, and Apple Sign-In while providing navigation and UI state management.

## Dependencies
The `LoginView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `GoogleSignIn` - For Google authentication.
- `FirebaseAuth` - For user authentication with Firebase.
- `FirebaseFirestore` - To retrieve user data from Firestore.
- `ActivityIndicatorView` - To display loading indicators.
- `AuthenticationServices` - For Apple Sign-In support.
- `LocalAuthentication` - For device authentication.

## Properties

### Text Fields
- `@State private var emailText: String` - Stores the email input.
- `@State private var passwordText: String` - Stores the password input.
- `@State private var isSecure: Bool` - Controls password field visibility.

### Authentication
- `@StateObject var userAuth = UserAuthViewModel()` - Manages user authentication.

### UI State
- `@State private var toast: Toast?` - Displays toast messages.
- `@State private var showLoadingIndicator: Bool` - Controls loading indicator visibility.

### Navigation
- `@State private var showCompany: Bool`
- `@State private var goToForm2: Bool`
- `@State private var goToHome: Bool`
- `@State private var willMoveToBankAccount: Bool`
- `@State private var willMoveToUnderReviewView: Bool`
- `@State private var moveToSignup: Bool`
- `@State private var goToForgotPassword: Bool`

### User Account State
- `@State private var isAccountCreated: Bool`
- `@State private var isBankCreated: Bool`
- `@State var isChecked: Bool` - For "Remember Me" checkbox.

## Views

### `body`
The main `LoginView` layout consists of:
- A `NavigationView`
- A `ZStack` containing:
  - `topArea` - Displays the app logo and sign-in prompt.
  - `textArea` - Includes email/password input fields and the "Remember Me" option.
  - `buttonArea` - Contains the login button and navigation links.
  - A loading indicator when authentication is in progress.

### `topArea`
- Displays the logo.
- Shows sign-in text.
- Provides a brief login instruction.

### `textArea`
- Contains:
  - Email input field.
  - Password input field with a toggle for secure entry.
  - "Remember Me" checkbox.
  - "Forgot Password" button.

### `buttonArea`
- Displays:
  - Navigation links to different app sections.
  - The main login button, which validates input and initiates sign-in.
  - A sign-up option.

## Methods

### `googleSignIn()`
- Initiates Google authentication.
- Uses `GIDSignIn.sharedInstance.signIn`.
- On successful sign-in, fetches user details from Firestore and navigates accordingly.

### `appleSocialLogin()`
- Handles Apple Sign-In.
- Checks existing user email and redirects based on account status.

### `authenticateAppPswd()`
- Uses `LocalAuthentication` to authenticate users via device security (Face ID, Touch ID, or passcode).

## Dropdown Components
Custom dropdown UI components:
- `DropdownOption` - Defines dropdown values.
- `DropdownRow` - Displays a single dropdown row.
- `Dropdown` - Manages dropdown items.
- `DropdownSelector` - Implements the dropdown selection interface.

## Navigation Destinations
The app navigates to different views based on the user’s account state:
- `CompanyView`
- `MainTabbedView`
- `NewsView`
- `SignUpView`
- `UnderReviewView`
- `ForgotPasswordView`
- `RepresentativeView`

## Error Handling
- Displays toast messages for errors (e.g., invalid email, weak password).
- Shows Firestore fetching errors in the console.

## Summary
The `LoginView.swift` file provides a full authentication interface with Firebase, Google, and Apple Sign-In support. It ensures seamless user navigation while handling different authentication scenarios.



