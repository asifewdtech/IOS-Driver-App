# PaymentDetailView.swift Documentation

## Overview
`PaymentDetailView.swift` is a SwiftUI-based payment processing screen in the Farepay app. It displays the fare details, calculates service fees, and allows users to initiate payments via Stripe Terminal.

## Dependencies
The `PaymentDetailView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `StripeTerminal` - For handling in-person payments.
- `UIKit` - For UI components and interactions.
- `ActivityIndicatorView` - For displaying loading indicators.
- `CoreLocation` - For fetching user location details.
- `FirebaseFirestore` - For retrieving and storing user information.
- `FirebaseAuth` - For handling user authentication.
- `Alamofire` - For making network requests.

## Properties

### Fare Details
- `@Binding var farePriceText: String` - Stores the fare amount entered by the user.
- `@State private var totalChargresWithTax: String` - Stores the total charge including tax.
- `@State private var totalAmount: Double` - Stores the total amount as a numeric value.
- `@State private var serviceFee: String` - Stores the service fee.
- `@State private var serviceFeeGst: String` - Stores the service fee GST.

### UI & Navigation State
- `@State private var willMoveTapToPayView: Bool` - Navigates to `ReaderConnectView` for tap-to-pay transactions.
- `@State private var willMoveToQr: Bool` - Navigates to `PayQRView` for QR payments.
- `@State var goToHome: Bool` - Navigates to `MainTabbedView` after successful payment.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator visibility.
- `@State private var toast: Toast?` - Displays toast messages.
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.

### Payment & Account State
- `@State private var collectedFeeStripe: String` - Stores the Stripe-collected fee.
- `@StateObject private var readerManager = ReaderConnectionManager()` - Manages Stripe reader connection.
- `@StateObject private var paymentManager = PaymentInitiationManager()` - Handles payment initiation.
- `@AppStorage("accountId") private var appAccountId: String` - Stores the user's account ID.

## Views

### `body`
The main `PaymentDetailView` layout consists of:
- A `ZStack` containing:
  - `topArea` - Displays fare details and calculated fees.
  - `buttonArea` - Contains the "Tap to Pay on iPhone" button to initiate payment.
  - `paymentStatusOverlay` - Handles payment status updates.
  - `loadingIndicatorView` - Displays a loading indicator if payment is in progress.

### `topArea`
- Displays:
  - The back button to return to `PaymentView`.
  - The fare input field with calculated total charges.
  - A breakdown of service fee, GST, and total amount.

### `buttonArea`
- Displays:
  - A "Tap to Pay on iPhone" button that triggers payment processing.

### `paymentStatusOverlay`
- Displays:
  - A loading indicator when processing.
  - A success message when payment is completed.
  - A failure message if the payment fails.

### `loadingIndicatorView`
- Displays an activity indicator during API calls.

## Methods

### `calculateFees()`
- Calculates:
  - Service fee (5% of fare).
  - Service fee GST.
  - Total charge including tax.
- Stores calculated values in `AmountDetail.instance`.

### `fetchFirebase()`
- Fetches:
  - Taxi number.
  - Driver ABN.
  - Driver license number.
- Updates `UserDefaults` with retrieved values.

### `fetchLatLong()`
- Requests location authorization and fetches latitude/longitude.

### `getAddressFromLatLong(latitude: Double, longitude: Double)`
- Calls the Google Maps API to retrieve address details from coordinates.

### `matrixAPICall()`
- Calls an API to calculate:
  - Service fee.
  - GST.
  - Total charge based on the user's location.
- Updates `AmountDetail.instance` with retrieved values.

## Navigation Destinations
- `MainTabbedView` - If payment is successful.
- `ReaderConnectView` - If tap-to-pay is initiated.
- `PayQRView` - If QR-based payment is chosen.

## Error Handling
- Displays toast messages for:
  - API failures in fetching fees.
  - Network errors in address retrieval.
  - Payment failures.

## Summary
The `PaymentDetailView.swift` file provides a complete payment processing experience, integrating fare calculation, Stripe Terminal payments, and user location services for accurate fee determination.


