# ForgotPasswordView.swift Documentation

## Overview
`ForgotPasswordView.swift` is a SwiftUI-based screen that allows users to reset their password by entering their email address. It integrates with Firebase Authentication to send a password reset link.

## Dependencies
The `ForgotPasswordView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For handling password reset requests.

## Properties

### User Input
- `@State private var emailText: String` - Stores the user's email input.

### UI State
- `@State private var toast: Toast?` - Displays toast messages for errors or success messages.
- `@State private var showForgotVerifiAlert: Bool` - Controls the alert visibility after a successful password reset request.

### Environment
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.

## Views

### `body`
The main `ForgotPasswordView` layout consists of:
- A `NavigationView` with a `ZStack` containing:
  - `topArea` - Displays the header with a back button and screen title.
  - `textArea` - Includes an email input field.
  - `BottomArea` - Contains the "Confirm" button to initiate the password reset.
  - An alert that notifies the user when a password reset email is sent.

### `topArea`
- Displays a back button (`backArrow` image) that dismisses the view.
- Shows the screen title "Forgot Password".

### `textArea`
- Contains an input field for the user to enter their email address.

### `BottomArea`
- Displays a "Confirm" button that triggers the password reset process.

## Methods

### `forgotPassword()`
- Validates the email input:
  - Ensures the email field is not empty.
  - Checks for a valid email format.
- Calls `Auth.auth().sendPasswordReset(withEmail:)` to send a password reset link.
- Handles errors based on `AuthErrorCode`:
  - `.invalidEmail` - Displays an error for invalid email format.
  - `.userNotFound` - Informs the user that no account exists with the given email.
  - `.networkError` - Displays a message for network-related issues.
  - `default` - Shows a general error message for other cases.
- If successful, it triggers `showForgotVerifiAlert`, informing the user that the reset email has been sent.

## Navigation Destinations
- The view does not navigate to another screen but allows users to return to the previous screen via the back button.

## Error Handling
- Uses toast messages to display errors related to:
  - Missing or invalid email input.
  - Firebase errors for incorrect email formats, non-existent accounts, or network issues.
- Shows an alert when the password reset email is sent.

## Summary
The `ForgotPasswordView.swift` file provides a simple and effective password reset flow using Firebase Authentication. It ensures proper validation, error handling, and user guidance through toast messages and alerts.


