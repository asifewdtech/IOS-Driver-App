# SignUpView.swift Documentation

## Overview
`SignUpView.swift` is a SwiftUI-based registration screen for the Farepay app. It allows users to create an account using Firebase Authentication, Google Sign-In, and Apple Sign-In. The view also manages user input validation and navigation.

## Dependencies
The `SignUpView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `ActivityIndicatorView` - For displaying loading indicators.
- `AuthenticationServices` - For Apple Sign-In support.
- `GoogleSignIn` - For Google authentication.
- `FirebaseAuth` - For handling user authentication with Firebase.
- `FirebaseFirestore` - To store and retrieve user information.

## Properties

### Text Fields
- `@State private var nameText: String` - Stores the user's name input.
- `@State private var emailText: String` - Stores the email input.
- `@State private var passwordText: String` - Stores the password input.
- `@State private var ReTypePasswordText: String` - Stores the re-entered password input.
- `@State private var isSecure: Bool` - Controls password field visibility.
- `@State private var isSecureReType: Bool` - Controls re-type password field visibility.

### Authentication
- `@StateObject var userAuth = UserAuthViewModel()` - Manages user authentication.

### UI State
- `@State private var toast: Toast?` - Displays toast messages.
- `@State private var showLoadingIndicator: Bool` - Controls loading indicator visibility.
- `@State private var showEmailVerifiAlert: Bool` - Displays an alert after a successful sign-up.

### Navigation
- `@State private var showCompany: Bool`
- `@State private var goToLogin: Bool`
- `@State private var goToHome: Bool`
- `@State private var willMoveToBankAccount: Bool`

### User Account State
- `@State private var isAccountCreated: Bool`
- `@State private var isBankCreated: Bool`
- `@State private var isChecked: Bool` - For the "Agree to Terms" checkbox.
- `@AppStorage("username") var username: String` - Stores the username.
- `@Environment(\.presentationMode) private var presentationMode` - Manages view dismissal.
- `@Environment(\.openURL) var openURL` - Opens URLs for terms and privacy policy.

## Views

### `body`
The main `SignUpView` layout consists of:
- A `ZStack` containing:
  - `topArea` - Displays the app logo and sign-up prompt.
  - `textArea` - Includes email/password input fields and terms agreement checkbox.
  - `buttonArea` - Contains the sign-up button and navigation links.
  - A loading indicator when authentication is in progress.

### `topArea`
- Displays the Farepay logo.
- Shows sign-up text.
- Provides an introduction to the registration process.

### `textArea`
- Contains:
  - Email input field.
  - Password input field with a toggle for secure entry.
  - Re-enter password field.
  - Password requirements message.
  - "Agree to Terms" checkbox with a link to Farepay’s Terms of Use and Privacy Policy.

### `buttonArea`
- Displays:
  - Navigation links to login, company details, and home screens.
  - The sign-up button, which validates input and initiates registration.
  - A sign-in option for existing users.

## Methods

### `callFirebaseRegisterAuth()`
- Handles Firebase user registration.
- Performs validation on email, password, and re-entered password.
- Ensures users accept the Terms of Use before signing up.
- Shows a success alert after registration.

### `googleSignIn()`
- Initiates Google authentication.
- Uses `GIDSignIn.sharedInstance.signIn`.
- On successful sign-in, fetches user details from Firestore and navigates accordingly.

### `appleSocialSignup()`
- Handles Apple Sign-In.
- Checks existing user email and redirects based on account status.

## Navigation Destinations
The app navigates to different views based on the user’s account state:
- `LoginView`
- `CompanyView`
- `MainTabbedView`
- `NewsView`

## Error Handling
- Displays toast messages for errors (e.g., invalid email, weak password).
- Shows Firestore fetching errors in the console.

## Summary
The `SignUpView.swift` file provides a full registration interface with Firebase, Google, and Apple Sign-In support. It ensures a smooth user experience with input validation, error handling, and navigation.



