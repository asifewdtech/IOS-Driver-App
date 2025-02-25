# EditAccountView.swift Documentation

## Overview
`EditAccountView.swift` is a SwiftUI-based screen in the Farepay app that allows users to edit their personal details, including name, phone number, and taxi number. The updated information is stored in Firebase Firestore.

## Dependencies
The `EditAccountView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For handling user authentication.
- `FirebaseFirestore` - For updating user account details.
- `ActivityIndicatorView` - For displaying a loading indicator.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@State var willMoveToEditInfo: Bool` - Tracks whether navigation to `EditAccountView` is needed.
- `@State private var nameText: String` - Stores the user’s name.
- `@State private var phoneText: String` - Stores the user’s phone number.
- `@State private var emailText: String` - Stores the user’s email address (read-only).
- `@State private var taxiText: String` - Stores the user’s taxi number.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator visibility.
- `@State private var toast: Toast?` - Displays validation and success messages.

## Views

### `body`
The main `EditAccountView` layout consists of:
- A `ZStack` containing:
  - A background color.
  - `topArea` - Displays the title and back button.
  - `textArea` - Displays form fields for user information.
  - `buttonArea` - Provides a "Save" button for updating details.
  - Calls `onAppear` to fetch user data from Firestore.
  - Displays an `ActivityIndicatorView` when `showLoadingIndicator` is `true`.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - The `"Account Info"` title.

### `textArea`
- Displays:
  - `"Your Name"` - Editable text field for the user's name.
  - `"Phone Number"` - Editable text field for the user's phone number.
  - `"Taxi Number"` - Editable text field for the user's taxi number.
  - `"Email Address"` - Read-only field displaying the user's email.

### `buttonArea`
- Displays:
  - `"Save"` button that updates the user’s details in Firestore after validation.

## Methods

### `onAppear`
- Fetches user details from Firestore.
- Retrieves:
  - `userName`
  - `phoneText`
  - `taxiText`

### `"Save"` Button Action
- Validates:
  - `nameText` is not empty.
  - `phoneText` has at least 9 digits.
  - `taxiText` is not empty and contains only uppercase letters and digits.
- If valid, updates Firestore with:
  - `"userName"`
  - `"phonenumber"`
  - `"taxiID"`
- Dismisses the view upon success.

## Navigation Destinations
- Returns to `AccountInfoView` after saving user details.

## Error Handling
- Displays toast messages for:
  - Missing or invalid input fields.
  - Incorrect phone number format.
  - Invalid taxi number format.
- Uses a loading indicator while updating data.

## Summary
The `EditAccountView.swift` file provides a structured and user-friendly interface for updating personal account details in the Farepay app. It ensures validation and real-time database updates for a seamless experience.



