# TapToPayView.swift Documentation

## Overview
`TapToPayView.swift` is a SwiftUI-based payment processing screen in the Farepay app. It facilitates contactless payments using Stripe Terminal's Tap to Pay functionality.

## Dependencies
The `TapToPayView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `StripeTerminal` - For handling in-person payments.
- `UIKit` - For UI components and interactions.
- `ActivityIndicatorView` - For displaying loading indicators.
- `CoreLocation` - For managing location services.

## Properties

### Payment & Account State
- `@State var farePriceText: String` - Stores the fare amount.
- `@State private var isDisabled: Bool` - Controls the editability of the fare input field.
- `@State private var willMoveToQr: Bool` - Navigates to `PayQRView` after a successful transaction.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator visibility.
- `@State private var toast: Toast?` - Displays toast messages for errors or status updates.
- `@State var fareBit: Int` - Placeholder for additional fare-related logic.
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.

### Device Interaction
- `@StateObject var readerDiscoverModel = ReaderDiscoverModel()` - Manages the Stripe reader connection.
- `@ObservedObject var locationManager = LocationManager()` - Handles device location updates.

## Views

### `body`
The main `TapToPayView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `PayQRView` upon successful payment.
  - A background color.
  - `tapArea` - Displays an image prompting users to tap and pay.
  - `ActivityIndicatorView` - Displays a loading indicator during payment processing.
- Calls `readerDiscoverModel.discoverReadersAction()` on appearance to initiate reader discovery.

### `topArea`
- Displays:
  - A back button to return to the previous screen.
  - The title `"Tap to Pay"`.
  - A read-only fare amount input field.

### `tapArea`
- Displays:
  - A tap-to-pay image indicating where users should tap their card.

## Methods

### `discoverReadersAction()`
- Initiates the discovery of available Stripe readers.
- If successful, calls `checkoutAction(amount:)` to begin payment collection.

### `checkoutAction(amount: String)`
- Converts the fare amount to an appropriate format.
- Creates a `PaymentIntent` using Stripe Terminal.
- Collects the payment method and confirms the transaction.

### `confirmPaymentIntent(_ paymentIntent: PaymentIntent)`
- Confirms the payment intent with Stripe.
- Captures the payment if online.
- Handles offline payments separately.

### `terminal(_: didUpdateDiscoveredReaders:)`
- Handles newly discovered Stripe readers.
- Connects to the first available reader and starts the checkout process.

## Navigation Destinations
- `PayQRView` - If payment is successful.

## Error Handling
- Displays toast messages for:
  - Failed reader discovery.
  - Payment failures.
  - Network issues.
- Logs errors in Stripe Terminal interactions.

## Summary
The `TapToPayView.swift` file provides an intuitive contactless payment interface using Stripe Terminal. It ensures smooth payment processing, handles errors, and seamlessly transitions to QR-based payments when necessary.

