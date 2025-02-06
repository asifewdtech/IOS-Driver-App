# AuthenticateFaceIdPswdView.swift Documentation

## Overview
`AuthenticateFaceIdPswdView.swift` is a SwiftUI-based authentication screen for the Farepay app. It provides biometric authentication using Face ID and passcode fallback to unlock the app.

## Dependencies
The `AuthenticateFaceIdPswdView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `LocalAuthentication` - For Face ID and passcode authentication.
- `UIKit` - For handling UI interactions.

## Properties

### Navigation State
- `@State private var willMoveToMainView: Bool` - Controls navigation to `MainTabbedView` after successful authentication.

### UI State
- `@State private var toast: Toast?` - Displays toast messages for authentication errors.
- `@Environment(\.dismiss) var dismiss` - Handles dismissing the view.

### Authentication
- `var context = LAContext()` - Manages Face ID and passcode authentication.

## Views

### `body`
The main `AuthenticateFaceIdPswdView` layout consists of:
- A `NavigationView` containing:
  - A `NavigationLink` to `MainTabbedView` upon successful authentication.
  - A `ZStack` with:
    - A background color.
    - `topArea` - Displays Face ID authentication instructions.
    - `buttonArea` - Contains the Face ID authentication button.
  - Calls `authenticateAppPswd()` when the view appears.

### `topArea`
- Displays:
  - The title `"Farepay Locked"`, indicating the app is secured.
  - Instructions prompting the user to unlock with Face ID.

### `buttonArea`
- Contains:
  - A "Use Face ID" button that calls `authenticateAppPswd()`.

## Methods

### `authenticateAppPswd()`
- Uses `LAContext` to check if Face ID authentication is available.
- Calls `evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)` for biometric authentication.
- If successful:
  - If it's the first Face ID authentication (`firstTimeFaceID == 1`), navigates to `MainTabbedView`.
  - Otherwise, dismisses the view.
- If Face ID fails:
  - Falls back to passcode authentication with `evaluatePolicy(.deviceOwnerAuthentication)`.
  - If passcode authentication is successful, dismisses the view.
- If neither Face ID nor passcode is available, prints an error message.

## Navigation Destinations
- `MainTabbedView` - If authentication is successful and it's the first Face ID login.

## Error Handling
- Handles Face ID and passcode authentication failures.
- Falls back to passcode authentication if Face ID is unavailable.
- Prints error messages for debugging.

## Summary
The `AuthenticateFaceIdPswdView.swift` file provides biometric authentication for unlocking the Farepay app. It ensures secure access while offering a passcode fallback for better user experience.


