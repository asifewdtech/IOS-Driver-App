# TransactionView.swift Documentation

## Overview
`TransactionView.swift` is a SwiftUI-based transaction history screen for the Farepay app. It allows users to view past transactions, filter by time periods, export transaction data as a CSV file, and navigate to transaction details.

## Dependencies
The `TransactionView` relies on the following frameworks:
- `SwiftUI` - For building the UI.
- `ActivityIndicatorView` - For showing a loading indicator.
- `UniformTypeIdentifiers` - For handling file exports.
- `Alamofire` - For making network requests.
- `CoreLocation` - For retrieving location details.

## Properties

### UI State
- `@Binding var presentSideMenu: Bool` - Controls the visibility of the side menu.
- `@State var transactionType: String` - Stores the selected transaction type (default: `"History"`).
- `@State var isExporting: Bool` - Controls the CSV export process.
- `@State private var showingOptions: Bool` - Displays the filter options.
- `@State private var selection: String` - Stores the selected filter.
- `@State private var isPresentedExport: Bool` - Controls the CSV export pop-up visibility.
- `@State var willMoveToTransactionDetailView: Bool` - Navigates to the transaction detail view.
- `@State private var csvFile: String` - Stores the CSV data for export.
- `@State private var showShareSheet: Bool` - Controls the share sheet for exported files.

### Transaction Data
- `@StateObject var transectionViewModel = TransectionViewModel()` - Manages transaction data.
- `@State var transactions: MyResult1?` - Stores the selected transaction for detail view navigation.

### API & Filters
- `@AppStorage("accountId") var accountId: String` - Stores the user's account ID.
- `@State private var dropdownlbl: String` - Stores the currently selected time filter (default: `"1 Week"`).
- `@State var weeklyTransection: String` - API endpoint for weekly transactions.
- `@State var todayTransection: String` - API endpoint for today's transactions.
- `@State var threeMonthlyTransection: String` - API endpoint for 3-month transactions.
- `@State var lifeTimeTransection: String` - API endpoint for lifetime transactions.
- `@State private var userAddress: String` - Stores the user's address.
- `@State var locManager = CLLocationManager()` - Handles location services.

### Formatting
- `let formatter = NumberFormatter()` - Formats transaction values.

## Views

### `body`
The main `TransactionView` layout consists of:
- A `ZStack` containing:
  - A `NavigationLink` to `TransactionDetailView` if a transaction is selected.
  - A background color.
  - `topArea` - Displays the title, side menu button, and export button.
  - `listView` - Shows a list of transactions or a "No Record Found" message.
  - Calls API on `onAppear` to fetch transactions.
  - Calls `toCSV()` on `onChange` of `transectionViewModel.apiCall` to generate CSV data.
  - Displays an `ActivityIndicatorView` if transactions are loading.

### `topArea`
- Displays:
  - A menu icon that toggles `presentSideMenu`.
  - The `"Transactions"` title.
  - A filter dropdown (`dropdownlbl`).
  - An `"Export"` button that initiates CSV export.

### `listView`
- Displays:
  - A `"No Record Found"` message if there are no transactions.
  - A scrollable list of transactions if available.
  - Tapping a transaction navigates to `TransactionDetailView`.

## Methods

### `onAppear`
- Fetches transactions from the appropriate API endpoint based on the environment (`Production`, `Dev`, `Stagging`).
- Calls `getAllTransection()` from `transectionViewModel` to retrieve transactions.
- Removes `"fareAddress"` from `UserDefaults`.

### `onChange`
- Generates a CSV file from transactions when `transectionViewModel.apiCall` changes.

### `convertUnixTimestamp(_ timestamp: Int) -> String`
- Converts a UNIX timestamp to a human-readable date format.

### `excldeFareTaxes(fareAmount: Int) -> String`
- Calculates and formats the fare amount excluding service fees and taxes.

### `saveCSVStringToFile(_ csvString: String, filename: String) -> URL?`
- Saves a CSV string to a file in the app's document directory.

## Navigation Destinations
- `TransactionDetailView` - Displays detailed transaction information.

## Error Handling
- Displays `"No Record Found"` when there are no transactions.
- Logs errors when fetching transactions from the API.
- Ensures CSV export processes data correctly.

## Summary
The `TransactionView.swift` file provides a comprehensive transaction history feature in the Farepay app. It enables users to view, filter, and export transaction data while maintaining a smooth user experience.


