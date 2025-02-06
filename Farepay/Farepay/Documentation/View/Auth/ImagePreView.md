# ImagePreView.swift Documentation

## Overview
`ImagePreView.swift` is a SwiftUI-based modal view that displays a preview of an image. Users can either delete or replace the selected image.

## Dependencies
The `ImagePreView` relies on the following frameworks:
- `SwiftUI` - For building the UI.

## Properties

### UI State
- `@Binding var presentedAsModal: Bool` - A binding variable to control the visibility of the modal.
- `@Binding var image: UIImage?` - A binding variable to store the image being previewed.

## Views

### `body`
The main layout consists of:
- A `ZStack` containing:
  - A semi-transparent black background.
  - A `VStack` with:
    - A title (`"Preview Image"`) to indicate the purpose of the modal.
    - A conditional `Image` view to display the selected image.
    - A horizontal button section with `"Delete"` and `"Replace"` options.

### `"Delete"` Button
- Removes the image by setting `image = nil`.
- Dismisses the modal using `presentedAsModal.dismiss()`.
- Styled with a red border and error color.

### `"Replace"` Button
- Intended for replacing the image.
- Styled with a white foreground and a primary button color.

### `ClearBackgroundView`
- A background view to enhance the modal's appearance.

## Summary
The `ImagePreView.swift` file provides an intuitive image preview interface with delete and replace functionality, enhancing user experience for image selection workflows.


