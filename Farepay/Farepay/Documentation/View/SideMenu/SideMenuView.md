# SideMenuView.swift Documentation

## Overview
`SideMenuView.swift` is a SwiftUI-based side menu component for the Farepay app. It provides navigation to different sections, including fare charging, transactions, terms of use, tap-to-pay guidelines, account settings, and logout functionality.

## Dependencies
The `SideMenuView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `FirebaseAuth` - For handling user authentication and logout.

## Properties

### Enum: `SideMenuRowType`
Defines different menu options with associated titles and icons.

#### Cases:
- `.chargeFare` → `"Charge Fare"`
- `.Transactions` → `"Transactions"`
- `.TermsofUse` → `"Terms of Use"`
- `.useTapToPay` → `"How to Tap to Pay"`

#### Properties:
- `title: String` - Returns the corresponding menu title.
- `iconName: UIImage` - Returns the associated menu icon.

### UI State
- `@Binding var selectedSideMenuTab: Int` - Stores the currently selected menu tab.
- `@Binding var presentSideMenu: Bool` - Controls the visibility of the side menu.
- `@Environment(\.rootPresentationMode) private var rootPresentationMode` - Manages root-level navigation.

## Views

### `body`
The main `SideMenuView` layout consists of:
- A `HStack` with:
  - A `ZStack` containing:
    - A `VStack` with a `ScrollView` displaying menu options.
    - `RowView` for each menu item.
    - A divider (`Color(.darkGrayColor)`) separating the menu from additional options.
    - `Account` and `Logout` buttons.
- A `Spacer` for layout adjustment.

### `RowView`
- A reusable menu row view.
- Displays:
  - An icon.
  - A title.
- Calls an `action()` when tapped.

### `Account` and `Logout`
- `Account` navigates to the account settings.
- `Logout`:
  - Calls `setUserLogin(false)`.
  - Attempts to sign the user out via `Auth.auth().signOut()`.
  - Dismisses the view using `rootPresentationMode.wrappedValue.dismiss()`.

## Methods

### `RowView(isSelected: Bool, img: UIImage, title: String, hideDivider: Bool = false, action: @escaping (()->()))`
- Creates an interactive menu row with an icon, title, and an optional divider.
- Changes background color if selected.

## Navigation Destinations
- `Charge Fare`
- `Transactions`
- `Terms of Use`
- `How to Tap to Pay`
- `Account`
- `Logout`

## Error Handling
- Ensures a safe logout process, catching any errors when calling `Auth.auth().signOut()`.

## Summary
The `SideMenuView.swift` file provides a structured and customizable side menu navigation experience for the Farepay app. It ensures seamless navigation and integrates authentication handling.

