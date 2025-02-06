# PayQRView.swift Documentation

## Overview
`PayQRView.swift` is a SwiftUI-based screen in the Farepay app that generates and displays a QR code receipt for a completed payment. It retrieves transaction details from Firestore and formats them for the receipt.

## Dependencies
The `PayQRView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `WebKit` - For embedding web views.
- `FirebaseAuth` - For retrieving the current user’s authentication status.
- `FirebaseFirestore` - For fetching transaction details.
- `FirebaseStorage` - For handling storage-related operations.

## Properties

### Navigation & UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@Environment(\.rootPresentationMode) private var rootPresentationMode` - Manages root-level navigation.
- `@State private var showWebView: Bool` - Controls the visibility of the web view.
- `@State var goToHome: Bool` - Navigates to the home screen.

### User & Payment Details
- `@State var taxiNumber: String?` - Stores the taxi number.
- `@State var driverABN: String?` - Stores the driver's Australian Business Number (ABN).
- `@State var driverID: String?` - Stores the driver's unique ID.
- `@State var qrUrl: String?` - Stores the URL for the generated QR code.
- `@State var stripeReceiptId: String?` - Stores the Stripe receipt ID.
- `@State var receiptDateTime: String?` - Stores the formatted date and time of the receipt.

### Number Formatting
- `@State private var formatter = NumberFormatter()` - Formats currency and numerical values.

## Views

### `body`
The main `PayQRView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `MainTabbedView` for returning home.
  - A background color.
  - A `ScrollView` wrapping:
    - `topArea` - Displays the receipt title and navigation buttons.
    - `successView` - Shows a confirmation message and payment amount.
    - `listView` - Displays a breakdown of the fare, service fee, and GST.
    - `qrView` - Generates and displays a QR code for the receipt.
    - `ButtonView` - Provides an option to return to the home screen.
- Calls Firestore on appearance to fetch user transaction details.

### `topArea`
- Displays:
  - A back button for navigation.
  - The title `"Receipt"`.
  - A home button to return to the main screen.

### `successView`
- Displays:
  - A success icon.
  - The `"Payment Successful"` message.
  - The total fare amount.

### `listView`
- Displays:
  - The fare, service fee, and GST in a formatted list.
  - Icons representing each charge type.

### `qrView`
- Generates and displays a QR code linking to the digital receipt.

### `ButtonView`
- Displays a `"Back to Home"` button for navigation.

## Methods

### `getQRCodeDate(text: String) -> Data?`
- Generates a QR code image from a provided text URL.
- Returns the QR code as PNG data.

### `convertUnixTimestamp(_ timestamp: Int) -> String`
- Converts a UNIX timestamp into a formatted string.

### `formatDateToDayDateTime(_ date: Date) -> String`
- Formats a given `Date` object into a readable string.

### `onAppear`
- Fetches user transaction details from Firestore.
- Formats and constructs the QR code URL.

## Navigation Destinations
- `MainTabbedView` - If the user chooses to return home.

## Error Handling
- Displays errors when fetching transaction details from Firestore.
- Logs issues related to QR code generation.

## Summary
The `PayQRView.swift` file provides a structured receipt view, allowing users to access payment details and generate a QR code for digital verification. It ensures accurate data retrieval, formatting, and navigation within the Farepay app.


