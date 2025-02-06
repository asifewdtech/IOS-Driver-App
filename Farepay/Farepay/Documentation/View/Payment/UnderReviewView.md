# UnderReviewView.swift Documentation

## Overview
`UnderReviewView.swift` is a SwiftUI-based screen in the Farepay app that informs users about their identity verification status. It integrates Stripe Identity verification and Firebase Firestore to track and update verification progress.

## Dependencies
The `UnderReviewView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `StripeCore`, `StripeIdentity`, `Stripe` - For handling identity verification via Stripe.
- `Alamofire` - For making network requests.
- `FirebaseAuth` - For retrieving user authentication details.
- `FirebaseFirestore` - For fetching and updating user verification data.
- `ActivityIndicatorView` - For displaying loading indicators.

## Properties

### Verification State
- `@State private var verifiStatusId: String?` - Stores the Stripe verification session ID.
- `@State private var verifiReportId: String?` - Stores the Stripe verification report ID.
- `@State private var verifiFileId1: String?` - Stores the file ID of the uploaded verification document.
- `@State private var fileIdBit: String?` - Tracks file upload status.
- `@State private var isVerifiSessionId: String?` - Stores the user's session ID.
- `@State private var verifiephemeralKeySecret: String?` - Stores the ephemeral key secret for Stripe identity verification.
- `@State private var verificaStatus: String` - Displays the current verification status.
- `@State private var verifiMessage: String` - Displays messages related to verification progress.

### UI State
- `@State private var showLoadingIndicator: Bool` - Controls the visibility of the loading indicator.
- `@State private var goToHome: Bool` - Navigates back to the home screen after verification.
- `@State private var toast: Toast?` - Displays toast messages for errors or status updates.
- `@State private var updateStripeDocs: Bool` - Triggers document re-upload if verification fails.
- `@State private var isPresentedPopUp: Bool` - Controls the visibility of the verification steps pop-up.
- `@State private var willMoveToForm2: Bool` - Navigates to the next form after verification.
- `@State private var isButtonActive: Bool` - Enables the retry button if verification fails.

## Views

### `body`
The main `UnderReviewView` layout consists of:
- A `NavigationView` containing:
  - A `ZStack` with:
    - Navigation links for different user flows.
    - A background color.
    - `topArea` - Displays verification status messages.
    - `buttonArea` - Provides a retry button for re-verification.
    - `ActivityIndicatorView` - Shows a loading indicator if verification is in progress.
- Calls `getVerificationStatus()` when the view appears.

### `topArea`
- Displays:
  - An image representing verification status.
  - A title indicating the current verification progress.
  - A message explaining the verification process.

### `buttonArea`
- Displays:
  - A `"Verification Identity Again"` button, visible when verification fails.

## Methods

### `createSessionStripeIdentity()`
- Calls an API to create a new Stripe identity verification session.
- Retrieves a `verificationSessionId` from the response.

### `getVerificationStatus()`
- Calls an API to fetch the user's verification status from Stripe.
- Updates `verificaStatus` and `verifiMessage` based on the response:
  - `"verified"` → Identity is verified, and the user can proceed.
  - `"requires_input"` → Verification failed, prompting the user to re-upload documents.
  - `"processing"` → Verification is still in progress, requiring a retry after some time.
  - `"canceled"` → Verification was canceled, requiring re-submission.

### `getVerificationReport()`
- Calls an API to retrieve the verification report from Stripe.
- Extracts the file IDs of uploaded verification documents.

### `CreateFileDownloadLink()`
- Calls an API to generate a downloadable link for the uploaded verification file.
- Saves the document locally for re-upload if needed.

### `imageFromUrl(urlString: String)`
- Downloads an image from a given URL and saves it locally.

### `saveImageToDocumentDirectory(image: UIImage)`
- Saves a verification document image to the local device.

### `FileUploadonStripe(fileImage: UIImage, name: String)`
- Uploads the saved verification document to Stripe.
- Updates Firestore with the uploaded file ID.

### `updateIdentityOnFB()`
- Updates Firestore with the user's verified status.

## Navigation Destinations
- `MainTabbedView` - If verification is successful.
- `RepresentativeView` - If additional details are required.

## Error Handling
- Displays toast messages for:
  - Failed API calls.
  - Verification errors.
  - Document upload failures.
- Implements automatic retries for verification status checks.

## Summary
The `UnderReviewView.swift` file ensures a smooth identity verification process in the Farepay app. It integrates with Stripe and Firebase to track verification progress, handle failures, and guide users through document re-submission when necessary.


