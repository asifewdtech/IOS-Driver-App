# MainTabbedView.swift Documentation

## Overview
`MainTabbedView.swift` is a SwiftUI-based tabbed navigation view that serves as the main dashboard for the Farepay app. It allows users to switch between different sections such as payments, transactions, terms & conditions, and account settings.

## Dependencies
The `MainTabbedView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `WebKit` - For embedding web views.

## Properties

### UI State
- `@State var presentSideMenu: Bool` - Controls the visibility of the side menu.
- `@State var selectedSideMenuTab: Int` - Stores the currently selected tab in the side menu.
- `@State private var showFaceIDPswdView: Bool` - Controls the Face ID/password authentication screen.

## Views

### `body`
The main `MainTabbedView` layout consists of:
- A `ZStack` containing:
  - A `switch` statement that determines which screen is displayed based on `selectedSideMenuTab`:
    - `0` → `PaymentView`
    - `1` → `TransactionView`
    - `2` → `TermsView`
    - `3` → `TapToPayGuidelinesView`
    - `5` → `AccountView`
    - `default` → `PaymentView`
  - A `SideMenu` that overlays the current view when `presentSideMenu` is `true`.

- Calls `onAppear` to listen for the `"appDidBecomeActive"` notification and trigger `showFaceIDPswdView`.

- Uses `.fullScreenCover` to present `AuthenticateFaceIdPswdView` when biometric authentication is required.

### `WebView`
- A `UIViewRepresentable` wrapper for displaying web pages inside the app.
- `makeUIView(context:)` initializes a `WKWebView` and loads the requested URL.
- `updateUIView(_:context:)` allows for updating the web view.

## Methods

### `onAppear`
- Adds an observer for the `"appDidBecomeActive"` notification.
- When triggered, sets `showFaceIDPswdView = true`, requiring users to authenticate with Face ID or a password.

## Navigation Destinations
- `PaymentView` - The primary payment processing screen.
- `TransactionView` - Displays transaction history.
- `TermsView` - Shows terms and conditions.
- `TapToPayGuidelinesView` - Provides tap-to-pay usage instructions.
- `AccountView` - Displays user account settings.
- `AuthenticateFaceIdPswdView` - Biometric authentication screen, shown as a full-screen modal.

## Error Handling
- Uses `default` in the `switch` statement to ensure `PaymentView` is displayed if an unknown tab index is encountered.
- Ensures `showFaceIDPswdView` is triggered correctly when the app becomes active.

## Summary
The `MainTabbedView.swift` file serves as the core navigation structure for the Farepay app, allowing users to access different sections efficiently while integrating Face ID authentication and a side menu for easy navigation.

