# CompanyView.swift Documentation

## Overview
`CompanyView.swift` is a SwiftUI-based view in the Farepay app responsible for verifying a user's identity before account activation. It integrates Stripe Identity Verification and Firebase to store user verification data.

## Dependencies
The `CompanyView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `Combine` - For handling reactive UI updates.
- `StripeIdentity` - For Stripe identity verification.
- `FirebaseAuth` - For handling user authentication.
- `FirebaseFirestore` - To store and retrieve user identity verification data.

## Properties

### User Input
- `@State var companyText: String = "Individual"` - Stores the selected company type.
- `@State private var cardText: String` - Stores the ABN (Australian Business Number).
- `@State private var contactText: String` - Stores the driver's license number.
- `@State private var licenseFrontImage: UIImage?` - Stores the uploaded identity document image.

### UI State
- `@State private var isPresentedPopUp: Bool` - Controls the visibility of the verification steps modal.
- `@State private var isStripeIdentityPickerPresented: Bool` - Manages Stripe identity verification UI.
- `@State private var isPresentingStripeIdentityVC: Bool` - Handles the presentation of the Stripe verification sheet.
- `@State private var identityStatus: String = "Identity Verification Pending"` - Tracks identity verification status.
- `@State private var showProceedBtn: Bool = false` - Controls the visibility of the "Proceed" button.
- `@State var isChecked: Bool` - Tracks the verification checkbox state.
- `@State private var toast: Toast?` - Displays toast messages.

### Navigation
- `@State private var willMoveToRepresentativeView: Bool` - Navigates to `RepresentativeView` after verification.
- `@State private var willMoveToUnderReviewView: Bool` - Navigates to `UnderReviewView` after verification.

### Firebase & Stripe
- `let db = Firestore.firestore()` - Firestore instance for database operations.

## Views

### `body`
The main `CompanyView` layout consists of:
- A `NavigationView` with two destination links (`RepresentativeView` and `UnderReviewView`).
- A `ZStack` containing:
  - `topArea` - Displays the verification heading and instructions.
  - `stripeIdentityView` - Contains an image upload field and verification status.
  - `buttonArea` - Shows the "Proceed" button when verification is complete.

### `topArea`
- Displays a heading prompting the user to verify their identity.
- Includes a subtitle explaining the need for identity verification.

### `stripeIdentityView`
- Shows an upload area for identity verification.
- Displays the current verification status.
- Allows users to tap to open Stripe’s identity verification process.

### `buttonArea`
- Displays the "Proceed" button if the verification process is completed.
- Calls `createAccOnFirebase()` when clicked.

## Methods

### `PresentedPopUp()`
- Checks if the Stripe verification flow has been completed.
- Displays an error toast if verification is incomplete.
- Navigates to `UnderReviewView` upon successful verification.

### `createAccOnFirebase()`
- Stores user verification data in Firestore.
- Includes details such as email, session ID, and verification status.
- Calls `PresentedPopUp()` upon successful Firestore update.

### `verifyDocs.didTapVerifyButton()`
- Sends a request to create a Stripe identity verification session.
- Calls `presentVerificationSheet()` upon receiving session details.

### `verifyDocs.presentVerificationSheet(verificationSessionId: String, ephemeralKeySecret: String)`
- Presents Stripe’s identity verification sheet.
- Updates the `stripeFlowStatus` in `UserDefaults` upon completion.
- Posts a `VerifiComplete` notification on successful verification.

## Navigation Destinations
The app navigates to different views based on the user’s identity verification status:
- `RepresentativeView` - If the verification is completed.
- `UnderReviewView` - If the verification is still pending.

## Error Handling
- Displays toast messages for verification errors.
- Logs Firestore writing errors to the console.
- Tracks and updates verification status through `UserDefaults`.

## Summary
The `CompanyView.swift` file provides a seamless identity verification process using Stripe and Firebase. It ensures proper validation, UI updates, and smooth navigation after verification.


