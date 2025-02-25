# ReferAFriendView.swift Documentation

## Overview
`ReferAFriendView.swift` is a SwiftUI-based view in the Farepay app that allows users to refer friends and track their referral rewards. The screen displays referral statistics, a step-by-step guide, and a shareable referral link.

## Dependencies
This file relies on the following frameworks:
- `SwiftUI` - For building the UI.

## Properties

### UI State
- `@Binding var presentSideMenu: Bool` - Controls the visibility of the side menu.
- `@State var willMoveToFriendList: Bool` - Determines whether to navigate to the `FriendlistView`.

## Views

### `body`
The main layout consists of:
- A `ZStack` containing:
  - A background color.
  - Navigation to `FriendlistView`.
  - `topArea` - Displays the title and menu button.
  - A `ScrollView` that contains:
    - `cardView` - Displays referral earnings.
    - `listView` - Explains the referral process.
    - `linkView` - Displays and shares the referral link.
    - `buttonArea` - Navigates to the friend list.

### `topArea`
- Displays:
  - A menu icon that toggles `presentSideMenu`.
  - The `"Refer A Friend"` title.

### `cardView`
- Displays referral statistics, including:
  - `"Get $50"` - Bonus amount.
  - `"Collected"` - Total earned.
  - `"Invites accepted"` and `"Total referrals earned"`.

### `listView`
- Provides step-by-step instructions for referring friends:
  - `"Invite your friends"` - Explanation of sharing via email or messenger.
  - `"Earn rewards"` - Describes how the referral system works.

### `linkView`
- Displays the referral link.
- Provides options to:
  - `"Copy"` - (Currently disabled).
  - `"Share"` - Enables sharing the referral link.

### `buttonArea`
- `"View List"` button navigates to `FriendlistView`.

## Navigation Destinations
- Navigates to `FriendlistView` upon tapping the `"View List"` button.

## Summary
The `ReferAFriendView.swift` file allows users to refer friends, track referral earnings, and share a unique referral link via messaging apps. The UI is designed to be user-friendly and informative, encouraging engagement with the referral system.


