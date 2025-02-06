# RepresentativeView.swift Documentation

## Overview
`RepresentativeView.swift` is a SwiftUI-based form that collects user details for driver registration in the Farepay app. It integrates Firebase Firestore, Stripe Identity verification, and Google Maps API for address validation.

## Dependencies
The `RepresentativeView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For retrieving the logged-in user's email.
- `FirebaseFirestore` - For storing and fetching user data.
- `Combine` - For handling reactive UI updates.
- `ActivityIndicatorView` - For showing loading indicators.
- `StripeIdentity` - For identity verification.
- `UIKit` - For working with images.
- `Alamofire` - For making network requests.
- `MapKit` - For geolocation and address validation.

## Properties

### User Input
- `@State private var userText: String` - Stores the user's full name.
- `@State private var dateText: String` - Stores the date of birth.
- `@State private var emailText: String` - Stores the user's email from Firebase.
- `@State private var mobileNumberText: String` - Stores the user's phone number.
- `@State private var addressText, postalAddressText, businessNumberText, authorityNumberText` - Store various user details.
- `@State private var driverABNText, driverLicenseText` - Store driver-related information.

### UI State
- `@State private var licenseFrontImage, licenseBackImage: UIImage?` - Store license images.
- `@State private var islicenseFrontImagePickerPresented, islicenseBackImagePickerPresented: Bool` - Track image picker states.
- `@State var showDatePicker: Bool` - Controls the visibility of the date picker.
- `@State var apicalled: Bool` - Tracks whether an API call is in progress.
- `@State private var toast: Toast?` - Displays error/success messages.
- `@State var verifyIdetityText: String` - Stores the identity verification status.

### Navigation
- `@State var goToNextView: Bool` - Navigates to the next view after form submission.

### Address & Location
- `@State var streetAddr, cityAddr, stateAddr, postalAddr, countryAddr: String` - Store user address details.
- `@State var locManager = CLLocationManager()` - Manages location services.
- `@State var currentLocation: CLLocation!` - Stores the current GPS location.

## Views

### `body`
The main `RepresentativeView` layout consists of:
- A `ZStack` containing:
  - A background color.
  - A `ScrollView` with:
    - `topArea` - Displays the form header.
    - `textArea` - Contains input fields for user details.
    - `buttonArea` - Provides form submission actions.
  - `DatePickerWithButtons` if `showDatePicker` is active.
  - `ActivityIndicatorView` if an API call is in progress.

### `topArea`
- Displays:
  - A title prompting the user to complete the form.
  - A progress indicator for registration.
  - A subtitle specific to driver registration.

### `textArea`
- Contains multiple input fields:
  - Full name, date of birth, email, mobile number.
  - Driver authority number, ABN, and license details.
  - Address fields including street, city, state, and postal code.
  - A checkbox for using the same address as the physical address.

### `buttonArea`
- Contains:
  - A "Create Account" button to validate and submit the form.
  - A navigation link to `NewsView`.

## Methods

### `callAddressValidationAPI()`
- Calls the Google Address Validation API.
- Checks if the provided address is valid.
- Updates `validateFormattedAddress` on success.
- Shows an error toast if the address is invalid.

### `callRegisterUserinfoAPI()`
- Collects form data and formats it for submission.
- Sends user details to the Farepay backend for account creation.
- Updates `goToNextView` on success.

### `getAddressFromLatLong(latitude: Double, longitude: Double)`
- Calls Google Maps API to fetch address details from GPS coordinates.
- Extracts street, city, state, and postal code from API response.

### `checkVerifyIden()`
- Checks the Stripe identity verification status.
- Updates `verifyIdetityText` based on the result.

### `GetVerifiedFieldsFromIdentity(reportId: String)`
- Fetches user identity details from Stripe.
- Updates user details like name and address.

### `GetSensitiveVerifiedFieldsFromIdentity(sessionId: String)`
- Fetches sensitive details like driver's license number and date of birth.
- Updates `dateText` and `driverLicenseText`.

## Navigation Destinations
- `NewsView` - If the form is successfully submitted.

## Error Handling
- Displays toast messages for:
  - Missing or invalid form fields.
  - Fake or invalid addresses.
  - Identity verification failures.
- Handles JSON decoding errors when fetching data.

## Summary
The `RepresentativeView.swift` file provides a complete driver registration form. It ensures proper data validation, address verification, identity confirmation via Stripe, and smooth navigation within the Farepay app.


