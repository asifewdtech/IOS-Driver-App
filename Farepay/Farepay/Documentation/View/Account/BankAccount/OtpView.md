# OtpView.swift Documentation

## Overview
`OtpView.swift` is a SwiftUI-based screen in the Farepay app that allows users to enter a 4-digit OTP (One-Time Password) for authentication. Upon successful entry, the user is navigated to the `MainTabbedView`.

## Dependencies
The `OtpView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `Combine` - For managing state updates.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@FocusState private var pinFocusState: FocusPin?` - Tracks which OTP input field is focused.
- `@State var pinOne: String` - Stores the first digit of the OTP.
- `@State var pinTwo: String` - Stores the second digit of the OTP.
- `@State var pinThree: String` - Stores the third digit of the OTP.
- `@State var pinFour: String` - Stores the fourth digit of the OTP.
- `@State private var willMoveToMainView: Bool` - Controls navigation to `MainTabbedView` after OTP validation.

## Views

### `body`
The main `OtpView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `MainTabbedView` for successful OTP validation.
  - A background color.
  - `topArea` - Displays the title and back button.
  - `otpView` - Displays the OTP input fields and a resend option.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - The `"Payout"` title.
  - An `optionIcon` on the right.

### `otpView`
- Displays:
  - An instruction text indicating where the OTP was sent.
  - Four input fields for OTP entry.
  - `"Didn’t receive the code?"` with a `"Resend"` option.

## Methods

### OTP Input Behavior
- When a user types in each OTP digit:
  - The focus moves to the next field.
  - On deletion, the focus moves back to the previous field.
- When all four digits are entered:
  - `setUserLogin(true)` is called to mark the user as logged in.
  - `willMoveToMainView.toggle()` is triggered, navigating to `MainTabbedView`.

## Navigation Destinations
- `MainTabbedView` - If the user successfully enters the OTP.

## Error Handling
- If the OTP is incorrect, an error handling mechanism (e.g., toast message) should be implemented (not included in this version).
- `"Resend"` option allows users to request a new OTP.

## Summary
The `OtpView.swift` file provides a structured and user-friendly OTP input interface in the Farepay app. It ensures a smooth experience by managing input focus, verifying the OTP, and handling user authentication.


