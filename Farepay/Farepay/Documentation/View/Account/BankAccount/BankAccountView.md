# BankAccountView.swift Documentation

## Overview
`BankAccountView.swift` is a SwiftUI-based screen in the Farepay app that allows users to view their linked bank accounts. It provides an interface for displaying existing bank accounts and adding new ones.

## Dependencies
The `BankAccountView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `ActivityIndicatorView` - For displaying a loading indicator.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@State var willMoveToNewAccount: Bool` - Controls navigation to `AddNewBankAccountView`.
- `@StateObject var bankAccountViewModel = BankAccountViewModel()` - Manages bank account data.
- `@State var showLoadingIndicator: Bool` - Controls the loading indicator visibility.

## Views

### `body`
The main `BankAccountView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `AddNewBankAccountView` for adding a new bank account.
  - A background color.
  - `topArea` - Displays the title and back button.
  - `listView` - Displays the user's saved bank accounts or a "No Record Found" message.
  - `bottomTextArea` - Provides instructions for updating bank details.
  - Calls `onAppear` to show a loading indicator for 4 seconds.
  - Displays an `ActivityIndicatorView` if `showLoadingIndicator` is `true`.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - The `"Bank Account"` title.

### `listView`
- Displays:
  - `"No Record Found"` if the user has no linked bank accounts.
  - A scrollable list of bank accounts, each showing:
    - Bank logo.
    - Bank name.
    - Masked account number (last 4 digits).
    - A star icon for favorite accounts.

### `buttonArea`
- Displays:
  - `"Add Bank Account"` button that navigates to `AddNewBankAccountView`.

### `bottomTextArea`
- Displays:
  - A message instructing users to contact support for updating bank details.

## Methods

### `onAppear`
- Displays a loading indicator for 4 seconds to simulate data fetching.

### `"Add Bank Account"` Button Action
- Navigates to `AddNewBankAccountView`.

## Navigation Destinations
- `AddNewBankAccountView` - If the user taps `"Add Bank Account"`.

## Error Handling
- Displays `"No Record Found"` when no bank accounts are available.
- Uses a loading indicator while fetching data.

## Summary
The `BankAccountView.swift` file provides a structured and user-friendly interface for managing bank accounts in the Farepay app. It ensures a smooth experience by displaying stored accounts and allowing users to add new ones.


