# MVVM Integration Guide

## Overview

The Savings Overview app now implements the MVVM (Model-View-ViewModel) architectural pattern for clean separation of concerns and testability.

## Architecture Diagram

```
┌─────────────┐     ┌──────────────┐     ┌────────────┐
│    View     │────▶│  ViewModel   │────▶│   Model    │
│  (SwiftUI)  │◀────│ (Observable) │◀────│  (Struct)  │
└─────────────┘     └──────────────┘     └────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │  Repository  │
                    └──────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │  Core Data   │
                    └──────────────┘
```

## ViewModels

### 1. DashboardViewModel

**Purpose**: Manages dashboard state and business logic

**Properties**:
- `@Published var accounts: [SavingsAccount]`
- `@Published var isLoading: Bool`
- `@Published var error: Error?`
- `@Published var showingAddAccount: Bool`

**Computed Properties**:
- `totalBalance: Double` - Sum of all account balances
- `totalMonthlyContribution: Double` - Sum of all contributions
- `accountCount: Int` - Number of accounts
- `sortedAccounts: [SavingsAccount]` - Accounts sorted by balance
- `hasAccounts: Bool` - Whether any accounts exist
- `chartData` - Formatted data for charts

**Methods**:
- `loadAccounts()` - Fetch accounts from repository
- `deleteAccount(_ account: SavingsAccount)` - Delete an account
- `projectedTotal(months: Int) -> Double` - Calculate total projected balance

**Usage**:
```swift
@StateObject private var viewModel: DashboardViewModel

init() {
    let repository = SavingsRepository(context: viewContext)
    _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: repository))
}

viewModel.loadAccounts()
Text(viewModel.totalBalance.asCurrency())
```

### 2. AccountListViewModel

**Purpose**: Manages account list filtering and sorting

**Properties**:
- `@Published var accounts: [SavingsAccount]`
- `@Published var searchText: String`
- `@Published var sortOption: SortOption`

**Computed Properties**:
- `filteredAndSortedAccounts: [SavingsAccount]` - Filtered and sorted results

**Methods**:
- `loadAccounts()` - Fetch accounts
- `filterAccounts(_:searchText:)` - Filter by search term
- `sortAccounts(_:by:)` - Sort by specified option

**Sort Options**:
- `.name` - Alphabetical by name
- `.balance` - Highest balance first
- `.institution` - Alphabetical by institution
- `.date` - Newest first

### 3. AddAccountViewModel

**Purpose**: Manages new account creation form

**Properties**:
- `@Published var name: String`
- `@Published var institution: String`
- `@Published var balanceText: String`
- `@Published var monthlyContributionText: String`
- `@Published var selectedColor: Color`
- `@Published var showingError: Bool`

**Computed Properties**:
- `isValid: Bool` - Whether form is valid
- `balance: Double?` - Parsed balance value
- `monthlyContribution: Double?` - Parsed contribution value
- `validationErrors: [String]` - List of validation errors

**Methods**:
- `save()` - Create new account
- `reset()` - Clear form

**Callbacks**:
- `onSave: (() -> Void)?` - Called after successful save

### 4. EditAccountViewModel

**Purpose**: Manages account editing

**Properties**:
- Same as AddAccountViewModel
- `let account: SavingsAccount` - Original account
- `@Published var showingDeleteConfirmation: Bool`

**Computed Properties**:
- `isValid: Bool`
- `hasChanges: Bool` - Whether any changes were made

**Methods**:
- `save()` - Update account
- `delete()` - Delete account

**Callbacks**:
- `onSave: (() -> Void)?`
- `onDelete: (() -> Void)?`

### 5. AccountDetailViewModel

**Purpose**: Manages account detail view logic

**Properties**:
- `@Published var projectionMonths: Int`
- `@Published var account: SavingsAccount`

**Computed Properties**:
- `currentBalance: Double`
- `monthlyContribution: Double`
- `annualGrowth: Double` - Yearly contribution amount
- `accountAge: String` - Formatted age
- `createdDate: String` - Formatted creation date
- `projectedBalance: Double` - Balance after selected months
- `milestones: [Milestone]` - Upcoming savings milestones

**Methods**:
- `projectionData() -> [ProjectionDataPoint]` - Data for chart

## Integrating ViewModels with Views

### Pattern 1: StateObject (Owner)

For views that own the ViewModel:

```swift
struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: DashboardViewModel
    
    init() {
        let repository = SavingsRepository(context: viewContext)
        _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: repository))
    }
    
    var body: some View {
        // Use viewModel...
    }
    
    .onAppear {
        viewModel.loadAccounts()
    }
}
```

### Pattern 2: ObservedObject (Passed)

For child views receiving a ViewModel:

```swift
struct ChildView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        // Use viewModel...
    }
}
```

### Pattern 3: Initializer Injection

For forms and detail views:

```swift
struct EditAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditAccountViewModel
    
    init(account: SavingsAccount) {
        let repository = SavingsRepository(context: viewContext)
        _viewModel = StateObject(wrappedValue: EditAccountViewModel(
            account: account,
            repository: repository
        ))
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.name)
            // ...
        }
        .toolbar {
            Button("Save") {
                viewModel.save()
            }
            .disabled(!viewModel.isValid)
        }
    }
}

viewModel.onSave = {
    dismiss()
}
```

## Benefits of MVVM

1. **Testability**: ViewModels can be unit tested without UI
2. **Separation of Concerns**: Business logic separate from UI
3. **Reusability**: ViewModels can be reused across views
4. **Maintainability**: Changes to business logic don't affect UI structure
5. **Type Safety**: Computed properties provide type-safe access to data

## Testing ViewModels

Example test:

```swift
@MainActor
final class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    var repository: SavingsRepository!
    
    override func setUp() async throws {
        let controller = PersistenceController(inMemory: true)
        repository = SavingsRepository(context: controller.container.viewContext)
        viewModel = DashboardViewModel(repository: repository)
    }
    
    func testTotalBalance() throws {
        // Given
        let account1 = SavingsAccount(...)
        let account2 = SavingsAccount(...)
        try repository.create(account1)
        try repository.create(account2)
        
        // When
        viewModel.loadAccounts()
        
        // Then
        XCTAssertEqual(viewModel.totalBalance, 3000.0)
    }
}
```

## Best Practices

1. **Keep ViewModels Focused**: One ViewModel per major view
2. **Use Computed Properties**: For derived state
3. **Handle Errors Gracefully**: Always set error state
4. **Async Operations**: Mark methods with async/await when needed
5. **MainActor**: Use @MainActor for ViewModels that update UI
6. **Dependency Injection**: Inject repository in initializer
7. **Callbacks**: Use closures for navigation events
8. **Validation**: Centralize validation logic in ViewModel

## Migration Guide

If you have existing views without ViewModels:

1. Create ViewModel class
2. Move business logic to ViewModel
3. Add @Published properties
4. Create computed properties for derived state
5. Update view to use @StateObject
6. Replace direct repository calls with ViewModel methods
7. Write tests for ViewModel

## Common Patterns

### Loading State
```swift
func loadData() {
    isLoading = true
    error = nil
    
    do {
        // Load data
        isLoading = false
    } catch {
        self.error = error
        isLoading = false
    }
}
```

### Form Validation
```swift
var isValid: Bool {
    !name.isEmpty &&
    !institution.isEmpty &&
    balance != nil
}
```

### Computed Summaries
```swift
var totalBalance: Double {
    accounts.reduce(0) { $0 + $1.balance }
}
```

### Navigation Callbacks
```swift
viewModel.onSave = {
    dismiss()
}
```

## Additional Resources

- [Apple's MVVM Documentation](https://developer.apple.com/documentation/swiftui/model-data)
- [Combine Framework](https://developer.apple.com/documentation/combine)
- [SwiftUI State Management](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)
