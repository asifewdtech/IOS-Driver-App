# ExportPopUpView.swift Documentation

## Overview
`ExportPopUpView.swift` is a SwiftUI-based modal pop-up that allows users to export their transaction history via email. It provides a clear user interface for confirming the export action or canceling it.

## Dependencies
The `ExportPopUpView` relies on the following frameworks:
- `SwiftUI` - For building the UI.

## Properties

### UI State
- `@Binding var presentedAsModal: Bool` - Controls the visibility of the modal pop-up.

## Views

### `body`
The main `ExportPopUpView` layout consists of:
- A `ZStack` containing:
  - A semi-transparent black background that dims the screen when the modal is open.
  - A centered `VStack` that displays:
    - A title prompting the user to export transaction history.
    - A brief message explaining the export process.
    - A horizontal button stack (`HStack`) with:
      - `"Cancel"` button: Dismisses the pop-up.
      - `"Email Summary"` button: Initiates the email export.

### `"Cancel"` Button
- Outlined button with a stroke.
- Calls `presentedAsModal.dismiss()` to close the pop-up.

### `"Email Summary"` Button
- Filled button with a background color.
- Uses `widthOfString(usingFont:)` to dynamically adjust button width.

### `ClearBackgroundView`
- Ensures a seamless pop-up background effect.

## Preview
- `ExportPopUpView_Previews` provides a preview with `presentedAsModal` set to `false`.

## Navigation Destinations
- No external navigation; the modal either dismisses or triggers the export process.

## Error Handling
- Ensures correct button width calculations for `"Email Summary"`.
- Uses `.constant(false)` in the preview to prevent unexpected modal behavior.

## Summary
The `ExportPopUpView.swift` file provides a clean and user-friendly export confirmation modal for transaction history. It enhances the user experience by providing clear options for canceling or proceeding with the export.


