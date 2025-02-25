# FriendlistView.swift Documentation

## Overview
`FriendlistView.swift` is a SwiftUI-based view in the Farepay app that displays a list of referred friends, their acceptance status, and referral earnings. The screen also provides an overview of the user’s referral earnings and total accepted invites.

## Dependencies
This file relies on the following frameworks:
- `SwiftUI` - For building the UI.

## Properties

### UI State
- `@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>` - Handles navigation back to the previous screen.

## Views

### `body`
The main layout consists of:
- A `ZStack` containing:
  - A background color.
  - `topArea` - Displays the title and back button.
  - A `ScrollView` that contains:
    - `cardView` - Displays referral earnings.
    - `listView` - Shows invited friends and their status.

### `topArea`
- Displays:
  - A back arrow icon that dismisses the view.
  - The `"Refer a Friend"` title.

### `cardView`
- Displays referral statistics, including:
  - `"Get $50"` - Bonus amount.
  - `"When friends transact"` - Description of the referral benefit.
  - `"Collected"` - The total amount earned.
  - `"Invites accepted"` - Number of accepted referrals.
  - `"Total referrals earned"` - Total amount earned through referrals.

### `listView`
- Displays:
  - `"Invited Friends"` - Header for the invited friends list.
  - `"Accepted"` status for each referred friend.
  - Uses a `ForEach` loop to display multiple friends.
  - Shows a separator line between entries.

## Navigation Destinations
- The back arrow navigates back to the previous screen.

## Summary
The `FriendlistView.swift` file allows users to view their referred friends, track referral acceptance, and monitor their earnings from the referral program. The interface is clean and simple, providing an overview of the user's referral activity.


