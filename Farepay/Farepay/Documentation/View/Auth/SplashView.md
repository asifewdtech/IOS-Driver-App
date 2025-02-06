# SplashView.swift Documentation

## Overview
`SplashView.swift` is a SwiftUI-based splash screen that determines the user's authentication and account status, then navigates them to the appropriate screen. It integrates Firebase Authentication and Firestore to retrieve user data.

## Dependencies
The `SplashView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `ActivityIndicatorView` - For displaying a loading indicator.
- `FirebaseAuth` - For handling user authentication.
- `FirebaseFirestore` - For retrieving and updating user data.

## Properties

### Navigation State
- `@State private var willMoveToLogin: Bool` - Navigates to the login screen.
- `@State private var willMoveToMainView: Bool` - Navigates to the main dashboard.
- `@State private var willMoveToCompanyView: Bool` - Navigates to the company verification screen.
- `@State private var willMoveToBankAccount: Bool` - Navigates to the bank account setup screen.
- `@State private var willMoveToUnderReviewView: Bool` - Navigates to the under-review screen.
- `@State private var willMoveToAuthPswd: Bool` - Navigates to the Face ID/password authentication screen.
- `@State private var willMoveToForm2: Bool` - Navigates to the second form screen.

### User Account State
- `@State private var isAccountCreated: Bool` - Tracks whether the user has completed account setup.
- `@State private var isBankCreated: Bool` - Tracks whether the user has added a bank account.
- `@State private var isAccountApproved: String` - Stores the verification status of the account.
- `@State private var isSessionID: String` - Stores the session ID from Stripe verification.
- `@State private var isIdentityVerified: Bool` - Tracks whether the user's identity has been verified.

### UI State
- `@State private var showLoadingIndicator: Bool = true` - Controls the visibility of the loading indicator.

### Persistent Storage
- `@AppStorage("accountId") var accountId: String` - Stores the user’s account ID for persistent access.

## Views

### `body`
The main `SplashView` layout consists of:
- A `NavigationView` containing multiple `NavigationLink` destinations:
  - `LoginView`
  - `CompanyView`
  - `NewsView`
  - `MainTabbedView`
  - `UnderReviewView`
  - `AuthenticateFaceIdPswdView`
  - `RepresentativeView`
- A `ZStack` containing:
  - A background color.
  - A `HStack` with the app logo and name.
  - A loading indicator for processing user state.
- An `onAppear` event to check the user’s authentication state and route them accordingly.

## Methods

### `navigateNext()`
- Determines the next screen based on the user’s authentication and account status.
- Runs after a 2-second delay to allow Firebase to load user data.
- Routes the user based on multiple conditions:
  - If all account requirements are met, navigates to `MainTabbedView`.
  - If the session ID exists but the account is incomplete, routes to `UnderReviewView`, `CompanyView`, or `BankAccountView` as needed.
  - If authentication is not found, redirects to `LoginView`.

### `UpdateVerificationDocs(accId: String, frontimgid: String)`
- Sends a request to update the user's verification documents via an API.
- Parses the response and updates the `accountId` if successful.

### `checkUserConnectAccount()`
- Fetches user account details from Firestore.
- Updates state variables with data retrieved from Firestore.
- Calls `navigateNext()` after processing user data.

## Navigation Destinations
- `LoginView` - If the user is not authenticated.
- `CompanyView` - If the user needs to complete business verification.
- `NewsView` - If the user needs to add a bank account.
- `MainTabbedView` - If the user has completed all requirements.
- `UnderReviewView` - If the account is still being reviewed.
- `AuthenticateFaceIdPswdView` - If Face ID/password authentication is required.
- `RepresentativeView` - If the user needs to complete an additional form.

## Error Handling
- Logs errors when fetching user data from Firestore.
- Displays error messages when updating verification documents fails.
- Uses Firebase Authentication error handling for session management.

## Summary
The `SplashView.swift` file serves as the entry point to the app, determining user authentication and account status before navigating them to the appropriate screen. It ensures smooth onboarding by integrating Firebase and Stripe verification while handling different user states efficiently.


