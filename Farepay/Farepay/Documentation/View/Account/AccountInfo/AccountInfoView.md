# AccountInfoView.swift Documentation

## Overview
`AccountInfoView.swift` is a SwiftUI-based screen in the Farepay app that allows users to view and edit their personal and contact information. It supports profile picture updates and provides access to an edit profile screen.

## Dependencies
The `AccountInfoView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For handling user authentication.
- `SDWebImageSwiftUI` - For loading and caching profile images.
- `FirebaseFirestore` - For fetching and updating user details.
- `FirebaseStorage` - For managing profile image uploads.
- `ActivityIndicatorView` - For displaying a loading indicator.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode` - Allows dismissing the view.
- `@State var willMoveToEditInfo: Bool` - Controls navigation to `EditAccountView`.
- `@State var userName: String` - Stores the user's name.
- `@State var phone: String` - Stores the user's phone number.
- `@State var tNumber: String?` - Stores the user's taxi number.
- `@State var showImagePicker: Bool` - Controls the display of the image picker.
- `@State var image: UIImage?` - Stores the selected profile image.
- `@State var url: String?` - Stores the user's profile image URL.
- `@StateObject var storageManager = StorageManager()` - Manages image uploads.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator visibility.

## Views

### `body`
The main `AccountInfoView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `EditAccountView` for profile editing.
  - A background color.
  - `topArea` - Displays the account title and back button.
  - `profileView` - Shows the user's profile picture, name, and email.
  - `infoView` - Displays personal and contact details.
  - `buttonArea` - Provides an "Edit" button for updating account details.
  - Calls `onAppear` to fetch user data from Firestore.
  - Shows an `ActivityIndicatorView` if `showLoadingIndicator` is `true`.

### `topArea`
- Displays:
  - A back button that dismisses the view.
  - The `"Account Info"` title.

### `profileView`
- Displays:
  - The user's profile image using `WebImage` from SDWebImageSwiftUI.
  - The user's name and email.
  - Allows users to tap the image to open the image picker.

### `infoView`
- Displays:
  - `"Personal Info"` - Contains:
    - `"Your Name"` - Displays the user's name.
  - `"Contact Info"` - Contains:
    - `"Phone Number"` - Displays the user's phone number.
    - `"Taxi Number"` - Displays the user's registered taxi number.
    - `"Email Address"` - Displays the user's email.

### `buttonArea`
- Displays an `"Edit"` button that navigates to `EditAccountView`.

## Methods

### `onAppear`
- Fetches user details from Firestore.
- Retrieves:
  - `userName`
  - `phone`
  - `tNumber`
  - Profile image URL (`imageUrl` from Firestore or `photoURL` from FirebaseAuth).

### `onTapGesture` (for profile image)
- Opens the image picker when tapped.
- Calls `storageManager.upload(image:)` to upload the new profile picture.

### `onChange(of: image)`
- Detects when a new image is selected.
- Triggers `showLoadingIndicator` while uploading.
- Calls `storageManager.upload(image:)` to update the profile picture.

## Supporting Components

### `OpenGallary`
- A `UIViewControllerRepresentable` that provides an image picker for selecting a profile picture.
- Uses `UIImagePickerController` for image selection.
- Handles image selection and cancellation.

### `StorageManager`
- A class that manages image uploads to Firebase Storage.
- Uploads images with compression quality set to `0.2`.
- Updates Firestore with the new profile image URL after successful upload.

## Navigation Destinations
- `EditAccountView` - If the user taps the `"Edit"` button.

## Error Handling
- Ensures correct formatting of user details.
- Catches Firestore errors when retrieving user data.
- Shows a loading indicator while uploading profile images.

## Summary
The `AccountInfoView.swift` file provides a structured interface for users to manage their personal information. It supports image uploads, displays user details, and allows easy navigation to profile editing.


