# PayoutView.swift Documentation

## Overview
`PayoutView.swift` is a SwiftUI-based view that allows users to view their payout details and choose between bank transfers and gift card options. It provides an overview of the user’s earnings, segment control for payout options, and detailed views for both bank transfers and gift cards.

## Dependencies
This file relies on the following frameworks:
- `SwiftUI` - For building the UI.

## Properties

### UI State
- `@Binding var presentSideMenu: Bool` - Controls the visibility of the side menu.
- `@State var isBankTransfer: Bool = true` - Determines whether the bank transfer view is shown.
- `@State var willMoveToGiftCardDetailView: Bool = false` - Controls navigation to the `GiftCardDetailView`.

## Views

### `body`
The main layout consists of:
- A `ZStack` containing:
  - A background color.
  - `topArea` - Displays the title and menu button.
  - `priceView` - Shows today's fees and lifetime savings.
  - `segmentView` - Provides options to switch between "Bank Transfer" and "Gift Cards."
  - `bankTransferView` or `giftCardView` - Displays the selected payout option.

### `topArea`
- Displays:
  - A menu icon that toggles the side menu.
  - The `"Payout"` title.

### `priceView`
- Displays:
  - `"Today’s Fees"` - The amount earned for the day.
  - `"Lifetime Savings"` - The total earnings over time.

### `segmentView`
- Provides a segmented control with two options:
  - `"Bank Transfer"` (default selection).
  - `"Gift Cards"`.
- Uses animations to switch between the two payout options.

### `bankTransferView`
- Displays:
  - `"Your Balance $888.88 will be automatically transferred to a bank account ending in **** 1564 within the next business day."`

### `giftCardView`
- Displays a scrollable grid of available gift cards.
- Each card contains:
  - A store logo.
  - The store name.
  - The number of available gift cards.
- Tapping a gift card navigates to `GiftCardDetailView`.

## Navigation Destinations
- `GiftCardDetailView` - Opens when a gift card is selected.
- The side menu can be toggled using the menu icon.

## Summary
The `PayoutView.swift` file provides users with an intuitive interface to manage their earnings, choose between bank transfers and gift cards, and view their payout details in a clean and structured manner.


