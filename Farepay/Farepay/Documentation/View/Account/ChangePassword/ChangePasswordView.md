# ChangePasswordView.swift Documentation

## Overview
`ChangePasswordView.swift` is a SwiftUI-based screen in the Farepay app that allows users to securely change their password. The view includes input fields for the old password, new password, and re-entered password, with built-in validation and Firebase authentication handling.

## Dependencies
The `ChangePasswordView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For handling password updates and user reauthentication.
- `ActivityIndicatorView` - For displaying a loading indicator.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@Environment(\.rootPresentationMode) private var rootPresentationMode` - Allows navigation control at the root level.
- `@State private var oldPasswordText: String` - Stores the old password input.
- `@State private var isSecureOldPassword: Bool` - Controls password visibility for the old password field.
- `@State private var newPasswordText: String` - Stores the new password input.
- `@State private var isSecureNewPassword: Bool` - Controls password visibility for the new password field.
- `@State private var reTypePasswordText: String` - Stores the re-entered new password.
- `@State private var isSecureReTypePassword: Bool` - Controls password visibility for the retype field.
- `let user = Auth.auth().currentUser` - Stores the currently authenticated Firebase user.
- `var credential: AuthCredential?` - Holds reauthentication credentials.
- `@State private var toast: Toast?` - Displays validation or success messages.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator.

## Views

### `body`
The main `ChangePasswordView` layout consists of:
- A `ZStack` containing:
  - A background color.
  - `topArea` - Displays the title and back button.
  - `textArea` - Displays input fields for password change.
  - `buttonArea` - Provides a "Confirm" button for updating the password.
  - Displays an `ActivityIndicatorView` if `showLoadingIndicator` is `true`.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - The `"Change Password"` title.

### `textArea`
- Displays:
  - `"Old Password"` - Secure input field for the old password.
  - `"New Password"` - Secure input field for the new password.
  - `"Re-Type New Password"` - Secure input field for confirming the new password.
- Each field supports:
  - Secure text entry toggle.
  - Validation to ensure password meets requirements.

### `buttonArea`
- Displays:
  - `"Confirm"` button that initiates password validation and Firebase authentication.

## Methods

### `"Confirm"` Button Action
- Validates:
  - `oldPasswordText` is not empty.
  - `newPasswordText` meets password complexity requirements.
  - `reTypePasswordText` matches `newPasswordText`.
- If valid:
  - Reauthenticates the user with `oldPasswordText` using Firebase.
  - Updates the password using `user?.updatePassword(to:)`.
  - Displays a success toast message.
  - Dismisses the view after successful password update.

### `updatePass()`
- Handles:
  - Password validation.
  - Firebase user reauthentication.
  - Secure password update.

## Error Handling
- Displays toast messages for:
  - Empty password fields.
  - Weak passwords.
  - Password mismatch errors.
  - Firebase authentication errors.
- Uses a loading indicator while updating the password.

## Summary
The `ChangePasswordView.swift` file provides a structured and secure way for users to update their passwords in the Farepay app. It ensures proper validation, Firebase authentication, and user feedback for a smooth experience.


