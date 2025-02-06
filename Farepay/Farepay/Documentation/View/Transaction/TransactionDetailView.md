# TransactionDetailView.swift Documentation

## Overview
`TransactionDetailView.swift` is a SwiftUI-based screen in the Farepay app that displays detailed information about a specific transaction. It provides users with a breakdown of charges, taxes, and the option to view a receipt.

## Dependencies
The `TransactionDetailView` relies on the following frameworks:
- `SwiftUI` - For building the UI.

## Properties

### Transaction Data
- `var transactionType: MyResult1` - Stores the transaction details passed to this view.

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@State private var willMoveToQr: Bool` - Controls navigation to `PayQRView`.
- `@State private var totalChargresWithTax: Double` - Stores the total charge amount including tax.
- `@State private var totalAmount: Double` - Stores the total transaction amount.
- `@State private var serviceFee: Double` - Stores the service fee amount.
- `@State private var serviceFeeGst: Double` - Stores the GST applied to the service fee.
- `@State private var serviceFeeStr: String` - Stores the formatted service fee.
- `@State private var serviceFeeGstStr: String` - Stores the formatted GST.
- `@State private var fareExcludeTax: String` - Stores the fare amount excluding tax.

## Views

### `body`
The main `TransactionDetailView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `PayQRView` for receipt viewing.
  - A background color.
  - `topArea` - Displays the transaction title and back button.
  - `cardView` - Shows transaction amount, date, and location.
  - `detailView` - Provides a detailed breakdown of charges.
  - Calls `onAppear` to format transaction values and update `AmountDetail.instance`.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - A title (`"Fare Processed"`) indicating the transaction type.

### `cardView`
- Displays:
  - The transaction amount (`$XX.XX`).
  - `"Charged at"` label.
  - Transaction date and location.

### `detailView`
- Displays:
  - `"Fare Inc GST"` - The total fare including GST.
  - `"Service Fee"` - The service fee charged.
  - `"Service Fee GST"` - The GST applied to the service fee.
  - A `"View Receipt"` button that navigates to `PayQRView`.

## Methods

### `onAppear`
- Formats transaction values using `NumberFormatter()`.
- Calculates:
  - `serviceFee` as 5% of the fare, divided by 1.1.
  - `serviceFeeGst` as the remaining portion of the 5% charge.
  - `totalChargresWithTax` as the sum of fare, service fee, and GST.
- Updates `AmountDetail.instance` with transaction details.
- Stores transaction metadata (`Address`, `fareStripeId`, `fareDateTimeInt`) in `UserDefaults`.

### `dateToString(date: Date) -> String`
- Converts a `Date` object into a human-readable format.

## Navigation Destinations
- `PayQRView` - If the user taps `"View Receipt"`.

## Error Handling
- Ensures proper formatting of monetary values.
- Logs transaction metadata for debugging.

## Summary
The `TransactionDetailView.swift` file provides a clear and structured transaction summary for users. It includes a breakdown of charges, formatted transaction details, and a seamless navigation flow for viewing receipts.


