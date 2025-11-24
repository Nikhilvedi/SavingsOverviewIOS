# SavingsOverview - Setup and Usage Guide

## Quick Start

### Option 1: Run as Standalone App in Xcode

1. **Open in Xcode**
   ```bash
   cd SavingsOverview
   open Package.swift
   ```

2. **Create an Xcode Project** (if needed)
   - File → New → Project
   - Select "iOS" → "App"
   - Product Name: "SavingsOverview"
   - Interface: SwiftUI
   - Language: Swift
   - Storage: Core Data
   - Click Next and save

3. **Add Files to Project**
   - Drag all files from SavingsOverview folder into your Xcode project
   - Ensure "Copy items if needed" is checked
   - Make sure all files are added to the target

4. **Replace Generated Files**
   - Replace the generated `ContentView.swift` with the one from Views folder
   - Replace the generated `[ProjectName]App.swift` with `SavingsOverviewApp.swift`
   - Replace the Core Data model with `SavingsDataModel.xcdatamodeld`

5. **Build and Run**
   - Select a target device or simulator (iOS 16.0+)
   - Press Cmd+R to build and run

### Option 2: Use SwiftUI Previews

You can preview individual views without running the full app:

1. Open any view file (e.g., `DashboardView.swift`)
2. Enable Canvas in Xcode (Editor → Canvas)
3. Click "Resume" in the preview pane
4. The preview will use sample data defined in the preview

## File Structure

```
SavingsOverview/
├── Models/
│   └── SavingsAccount.swift          # Swift model with sample data
├── Persistence/
│   ├── SavingsDataModel.xcdatamodeld  # Core Data model
│   ├── SavingsAccountEntity+*.swift   # Core Data entity classes
│   ├── SavingsAccountConversions.swift # Model ↔ Entity conversions
│   ├── PersistenceController.swift    # Core Data stack
│   └── SavingsRepository.swift        # CRUD operations
├── Utilities/
│   ├── ColorExtensions.swift          # Color ↔ Hex conversions
│   └── CurrencyFormatter.swift        # Currency formatting
├── Views/
│   ├── ContentView.swift              # Main tab view
│   ├── DashboardView.swift            # Dashboard with charts
│   ├── AccountListView.swift          # List of accounts
│   ├── AccountDetailView.swift        # Account details
│   ├── AddAccountView.swift           # Add new account
│   ├── EditAccountView.swift          # Edit account
│   ├── ProjectionChartView.swift      # Projection chart component
│   ├── AccountCardView.swift          # Account card component
│   └── SettingsView.swift             # Settings
├── SavingsOverviewApp.swift           # App entry point
├── Package.swift                      # Swift Package manifest
├── Info.plist                         # App configuration
└── README.md                          # Documentation
```

## Features Overview

### 1. Dashboard View
- **Total Balance Card**: Shows aggregate balance across all accounts
- **Bar Chart**: Visualizes balance distribution across accounts
- **Account Cards**: Quick overview of each account with color coding
- **Add Button**: Quick access to add new accounts

### 2. Account Management
- **Add Account**: Form with validation for creating new accounts
  - Name and institution
  - Current balance
  - Monthly contribution
  - Color selection from predefined palette
- **Edit Account**: Modify existing account details
- **Delete Account**: Remove account with confirmation dialog

### 3. Account Details
- **Current Balance**: Large, prominent display
- **Statistics**: Monthly contribution, account age, annual growth
- **Projection Chart**: Interactive chart showing future balance (6, 12, 18, or 24 months)
- **Milestones**: Progress toward savings goals ($10K, $25K, $50K, $100K)

### 4. Projection Visualization
- Uses Swift Charts for beautiful visualizations
- Line chart with gradient area
- Configurable time period
- Shows current vs. projected balance

### 5. Settings
- App information
- Data statistics
- Export placeholder (coming soon)
- Data management (delete all accounts)

## Code Architecture

### Core Data Integration

The app uses Core Data for local persistence:

```swift
// Create
let account = SavingsAccount(...)
let repository = SavingsRepository(context: viewContext)
try repository.create(account)

// Update
try repository.update(modifiedAccount)

// Delete
try repository.delete(account)

// Fetch (using @FetchRequest in views)
@FetchRequest(sortDescriptors: [...]) var accounts: FetchedResults<SavingsAccountEntity>
```

### Model Conversions

Swift models are converted to/from Core Data entities:

```swift
// Swift model → Core Data entity
let entity = account.toManagedObject(context: viewContext)

// Core Data entity → Swift model
if let account = SavingsAccount.fromManagedObject(entity) {
    // Use account
}
```

### Color System

Accounts use hex colors for consistency:

```swift
// Create color from hex
let color = Color(hex: "#FF6B6B")

// Convert color to hex
let hex = color.toHex() // Returns "#FF6B6B"

// Predefined colors
Color.accountColors  // Array of 10 predefined colors
Color.randomAccountColor()  // Get random color
```

### Currency Formatting

Double and Int extensions for currency:

```swift
let balance = 1234.56
balance.asCurrency()  // Returns "$1,234.56"
```

## SwiftUI Previews

All views include preview providers with sample data:

```swift
#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
```

The preview controller creates in-memory Core Data store with sample data.

## Sample Data

Three sample accounts are included:

1. **Emergency Fund** (Chase Bank)
   - Balance: $5,000
   - Monthly: $500
   - Color: Red (#FF6B6B)

2. **Vacation Fund** (Wells Fargo)
   - Balance: $2,500
   - Monthly: $250
   - Color: Teal (#4ECDC4)

3. **House Down Payment** (Bank of America)
   - Balance: $15,000
   - Monthly: $1,000
   - Color: Mint (#95E1D3)

## Requirements

- **iOS**: 16.0 or later
- **Xcode**: 14.0 or later
- **Swift**: 5.7 or later
- **Frameworks**: SwiftUI, Core Data, Charts

## Customization

### Adding More Colors

Edit `ColorExtensions.swift`:

```swift
static let accountColors: [Color] = [
    Color(hex: "#FF6B6B"),
    Color(hex: "#4ECDC4"),
    // Add more colors here
]
```

### Changing Milestones

Edit `AccountDetailView.swift`:

```swift
ForEach([10000, 25000, 50000, 100000], id: \.self) { milestone in
    // Add or modify milestone values
}
```

### Modifying Chart Periods

Edit `AccountDetailView.swift`:

```swift
Picker("Months", selection: $projectionMonths) {
    Text("6 months").tag(6)
    Text("12 months").tag(12)
    // Add more options
}
```

## Troubleshooting

### Core Data Model Not Found
- Ensure `SavingsDataModel.xcdatamodeld` is added to target
- Check Build Phases → Copy Bundle Resources

### Preview Not Working
- Make sure preview provider is at bottom of file
- Verify `PersistenceController.preview` is accessible
- Try cleaning build folder (Cmd+Shift+K)

### Colors Not Displaying
- Verify hex strings start with '#'
- Check `ColorExtensions.swift` is included in target

### Build Errors
- Ensure iOS deployment target is 16.0+
- Verify all files are added to the correct target
- Clean build folder and rebuild

## Next Steps

### Planned Features
- [ ] Export data to CSV/JSON
- [ ] Import data from file
- [ ] Budget goals and alerts
- [ ] Historical balance tracking
- [ ] Multiple currencies
- [ ] iCloud sync
- [ ] Home Screen widgets
- [ ] Dark mode optimization
- [ ] Accessibility improvements

### Contributing
Feel free to extend the app with additional features:
- Add new chart types
- Implement data export
- Add notification reminders
- Create widgets
- Add investment tracking

## License

This is a sample application for demonstration purposes.
