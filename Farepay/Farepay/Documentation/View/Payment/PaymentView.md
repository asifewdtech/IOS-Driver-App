# PaymentView.swift Documentation

## Overview
`PaymentView.swift` is a SwiftUI-based payment interface for the Farepay app. It allows users to enter fare amounts, verify their taxi number, and initiate payments via different methods. The view integrates Firebase Firestore, authentication, and local device authentication.

## Dependencies
The `PaymentView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `ActivityIndicatorView` - For displaying a loading indicator.
- `FirebaseAuth` - For handling user authentication.
- `FirebaseFirestore` - For retrieving and storing user payment details.
- `LocalAuthentication` - For device-based authentication (Face ID/Touch ID).

## Properties

### UI & Navigation State
- `@State private var willMoveToPaymentDetail: Bool` - Navigates to `PaymentDetailView`.
- `@State private var willMoveTapToPayView: Bool` - Navigates to `TapToPayView`.
- `@State private var willMoveToQr: Bool` - Navigates to `PayQRView`.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator visibility.
- `@State private var showPopupView: Bool` - Manages visibility of popups.
- `@Binding var presentSideMenu: Bool` - Controls the display of the side menu.

### Payment & Account State
- `@ObservedObject private var currencyManager = CurrencyManager(amount: 0)` - Manages the fare amount and calculations.
- `@State private var FareAmount: String` - Stores the entered fare amount.
- `@State private var taxiNumber: String` - Stores the taxi number.
- `@AppStorage("accountId") private var appAccountId: String` - Stores the user's account ID.
- `@State private var accStatusStr: String` - Stores the account status (`pending`, `paused`, or `live`).
- `@State private var accStatusBool: Bool` - Indicates if the account status requires approval.

## Views

### `body`
The main `PaymentView` layout consists of:
- A `NavigationView` with multiple `NavigationLink` destinations:
  - `PaymentDetailView`
  - `TapToPayView`
  - `PayQRView`
- A `ZStack` containing:
  - A background color.
  - `topArea` - Displays the app logo, navigation menu, and fare input field.
  - `taxiNumberArea` - Allows users to enter their taxi number.
  - `keypadArea` - Provides a numeric keypad for fare entry.
  - `buttonArea` - Contains the "CHARGE" button to proceed with payment.
  - `ActivityIndicatorView` if an operation is in progress.

### `topArea`
- Displays:
  - The Farepay logo.
  - The fare input field where users enter their amount.

### `taxiNumberArea`
- Displays:
  - A button for entering a taxi number.
  - A popup for users to input and save their taxi plate number.

### `keypadArea`
- Displays a numeric keypad that allows users to enter a fare amount.

### `buttonArea`
- Contains:
  - A "CHARGE" button that validates the fare and proceeds to `PaymentDetailView`.

## Methods

### `firebaseAPI()`
- Fetches the user's stored taxi number from Firestore.

### `transactionSuccess()`
- Handles successful transactions and navigates to the QR payment view.

### `retriveAccountAPI()`
- Calls an API to check the user's account status.
- Updates `accStatusStr` and `accStatusBool` based on the response.
- Triggers an approval status notification if required.

### `handleAccountStatus()`
- Displays an alert message if the account is `pending` or `paused`.

### `sendApprovalGateEmailToAdmin()`
- Sends an email to the admin requesting account approval.
- Uses Firestore's email-sending functionality.

## Navigation Destinations
- `PaymentDetailView` - If the fare is valid.
- `TapToPayView` - If tap-to-pay is selected.
- `PayQRView` - If QR-based payment is chosen.

## Error Handling
- Displays toast messages for:
  - Missing taxi number.
  - Invalid or insufficient fare amount.
  - Account approval status issues.
- Handles API request failures for account retrieval.

## Summary
The `PaymentView.swift` file provides a structured and efficient payment interface for Farepay. It ensures smooth user interactions with validation checks, UI updates, and backend integrations.


