# AddNewBankAccountView.swift Documentation

## Overview
`AddNewBankAccountView.swift` is a SwiftUI-based screen in the Farepay app that allows users to add a new bank account. The form collects the account holder's name, BSB number, and account number and submits the details to a backend API.

## Dependencies
The `AddNewBankAccountView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For managing user authentication.
- `FirebaseFirestore` - For checking existing user bank details.
- `ActivityIndicatorView` - For displaying a loading indicator.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@Environment(\.rootPresentationMode) private var rootPresentationMode` - Allows navigation control at the root level.
- `@State var bankName: String` - Stores the bank name.
- `@State var goToHome: Bool` - Controls navigation to the home screen.
- `@State var accountNumber: String` - Stores the bank account number.
- `@State var bsbNumber: String` - Stores the bank BSB number.
- `@State var accountHolderName: String` - Stores the account holder’s name.
- `@ObservedObject var completeFormViewModel = CompleteFormViewModel()` - Manages form submission and API interactions.
- `@AppStorage("accountId") var accountId: String` - Stores the user's account ID.
- `@State private var toast: Toast?` - Displays validation or error messages.
- `@State var apicalled: Bool` - Controls the API call state.
- `@State private var isBankCreated: Bool` - Checks if the bank account is already linked.

## Views

### `body`
The main `AddNewBankAccountView` layout consists of:
- A `ZStack` containing:
  - A background color.
  - `topArea` - Displays the title and back button.
  - `textArea` - Displays the form fields for bank account details.
  - `buttonArea` - Provides a "Confirm" button for submitting the details.
  - Calls `onAppear` to check if the user already has a bank account.
  - Displays an `ActivityIndicatorView` if `apicalled` is `true`.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - The `"Add Bank Account"` title.

### `textArea`
- Displays:
  - `"Please be sure to double check these bank details..."` - Instructions for users.
  - `"Account Holder's Name"` - Input field for the account holder’s name.
  - `"BSB Number"` - Input field for the 6-digit BSB number.
  - `"Account Number"` - Input field for the 6-10 digit account number.

### `buttonArea`
- Displays:
  - `"Confirm"` button that validates and submits the bank details to an API.

## Methods

### `onAppear`
- Sets `"firstTime"` flag in `UserDefaults`.
- Calls `checkUserBankAccount()` to determine if a bank account is already linked.

### `"Confirm"` Button Action
- Validates:
  - `accountHolderName` is not empty.
  - `bsbNumber` is exactly 6 digits.
  - `accountNumber` is between 6-10 digits.
- If valid:
  - Calls an API endpoint (`CreateBankAccount`) to store bank details.
  - Shows a loading indicator while submitting.
  - If successful, navigates to `MainTabbedView`.
  - Displays an error toast if the request fails.

### `checkUserBankAccount()`
- Fetches user data from Firestore.
- Retrieves the `bankAdded` flag to check if the user already has a linked bank account.

## Navigation Destinations
- `MainTabbedView` - If the user successfully adds a new bank account.

## Error Handling
- Displays toast messages for:
  - Missing or invalid input fields.
  - API errors.
  - Issues with account number format.
- Uses a loading indicator while processing the request.

## Summary
The `AddNewBankAccountView.swift` file provides a structured and user-friendly interface for adding a bank account in the Farepay app. It ensures proper validation, API integration, and user feedback for a smooth experience.


