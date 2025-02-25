# AccountView.swift Documentation

## Overview
`AccountView.swift` is a SwiftUI-based screen in the Farepay app that allows users to manage their account settings. It includes options for updating profile information, changing passwords, and managing bank account details.

## Dependencies
The `AccountView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For handling authentication and fetching user details.
- `SDWebImageSwiftUI` - For loading and caching profile images.
- `FirebaseFirestore` - For retrieving user account information.
- `ActivityIndicatorView` - For displaying a loading indicator.

## Properties

### UI State
- `@Binding var presentSideMenu: Bool` - Controls the visibility of the side menu.
- `@State var willMoveToAccountInfo: Bool` - Controls navigation to `AccountInfoView`.
- `@State var willMoveToChangePassword: Bool` - Controls navigation to `ChangePasswordView`.
- `@State var willMoveToBankAccount: Bool` - Controls navigation to `BankAccountView`.
- `@State var url: String?` - Stores the user's profile image URL.
- `@State var showImagePicker: Bool` - Controls the display of the image picker.
- `@State var image: UIImage?` - Stores the selected profile image.
- `@StateObject var storageManager = StorageManager()` - Manages image uploads.
- `@State var userName: String` - Stores the user's name.
- `@State private var showLoadingIndicator: Bool` - Controls the loading indicator visibility.

## Views

### `body`
The main `AccountView` layout consists of:
- A `ZStack` containing:
  - Navigation links to:
    - `AccountInfoView`
    - `ChangePasswordView`
    - `BankAccountView`
  - A background color.
  - `topArea` - Displays the account title and side menu button.
  - `profileView` - Shows the user’s profile picture, name, and email.
  - `listView` - Provides navigation options for account info, changing passwords, and managing bank details.
  - Calls `onAppear` to fetch user data from Firestore.
  - Shows an `ActivityIndicatorView` if `showLoadingIndicator` is `true`.

### `topArea`
- Displays:
  - A side menu button that toggles `presentSideMenu`.
  - The `"Account"` title.

### `profileView`
- Displays:
  - The user's profile image using `WebImage` from SDWebImageSwiftUI.
  - The user's name and email.
  - Allows users to tap the image to open the image picker.

### `listView`
- Displays:
  - `"Account Info"` - Navigates to `AccountInfoView`.
  - `"Change Password"` - Navigates to `ChangePasswordView` (only if the user is not using social login).
  - `"Bank Account"` - Navigates to `BankAccountView`.

## Methods

### `onAppear`
- Fetches user details from Firestore.
- Retrieves:
  - `userName`
  - Profile image URL (`imageUrl` from Firestore or `photoURL` from FirebaseAuth).

### `onTapGesture` (for profile image)
- Opens the image picker when tapped.
- Calls `storageManager.upload(image:)` to upload the new profile picture.

### `onChange(of: image)`
- Detects when a new image is selected.
- Triggers `showLoadingIndicator` while uploading.
- Calls `storageManager.upload(image:)` to update the profile picture.

## Navigation Destinations
- `AccountInfoView` - For editing personal details.
- `ChangePasswordView` - For updating the account password.
- `BankAccountView` - For managing bank details.

## Error Handling
- Ensures proper formatting of user details.
- Catches Firestore errors when retrieving user data.
- Shows a loading indicator while uploading profile images.

## Summary
The `AccountView.swift` file provides a structured user account management interface. It allows users to update their profile information, manage security settings, and access their banking details in an intuitive way.


