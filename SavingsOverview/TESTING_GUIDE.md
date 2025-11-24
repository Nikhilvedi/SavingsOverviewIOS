# Testing Guide

## Overview

The Savings Overview app includes comprehensive test coverage with unit tests and UI tests.

## Test Structure

```
SavingsOverview/
├── Tests/
│   ├── ModelTests/
│   │   └── SavingsAccountModelTests.swift
│   ├── RepositoryTests/
│   │   └── SavingsRepositoryTests.swift
│   ├── UtilityTests/
│   │   ├── ColorExtensionsTests.swift
│   │   └── CurrencyFormatterTests.swift
│   └── ViewModelTests/
│       ├── DashboardViewModelTests.swift
│       └── AccountDetailViewModelTests.swift
└── UITests/
    ├── SavingsOverviewUITests.swift
    └── AccountManagementUITests.swift
```

## Unit Tests

### Model Tests (SavingsAccountModelTests)

Tests the SavingsAccount model:

**Coverage**:
- ✅ Account initialization
- ✅ Projected balance calculations (0, 1, 12 months)
- ✅ Projected balance with zero contribution
- ✅ Codable conformance (encoding/decoding)
- ✅ Sample data existence

**Example**:
```swift
func testProjectedBalanceTwelveMonths() {
    // Given
    let account = SavingsAccount(
        name: "Test",
        institution: "Test Bank",
        balance: 5000.0,
        monthlyContribution: 500.0,
        colorHex: "#FF6B6B"
    )
    
    // When
    let projected = account.projectedBalance(months: 12)
    
    // Then
    XCTAssertEqual(projected, 11000.0) // 5000 + (500 * 12)
}
```

### Repository Tests (SavingsRepositoryTests)

Tests CRUD operations with in-memory Core Data:

**Coverage**:
- ✅ Create account
- ✅ Fetch all accounts
- ✅ Update account
- ✅ Delete account
- ✅ Fetch from empty database
- ✅ Multiple operations

**Setup**:
```swift
override func setUp() {
    super.setUp()
    persistenceController = PersistenceController(inMemory: true)
    repository = SavingsRepository(context: persistenceController.container.viewContext)
}
```

**Key Pattern**: Uses in-memory Core Data store for isolation

### Utility Tests

#### ColorExtensionsTests
- ✅ Color from valid hex
- ✅ Color from hex without hash
- ✅ Color to hex conversion
- ✅ Color round-trip conversion
- ✅ Account colors palette
- ✅ Random color generation

#### CurrencyFormatterTests
- ✅ Double as currency
- ✅ Zero as currency
- ✅ Negative amounts
- ✅ Large amounts
- ✅ Integer as currency
- ✅ Decimal precision

### ViewModel Tests

#### DashboardViewModelTests

Tests dashboard business logic:

**Coverage**:
- ✅ Initial state
- ✅ Load accounts
- ✅ Total balance calculation
- ✅ Total monthly contribution
- ✅ Sorted accounts (by balance)
- ✅ Projected total
- ✅ Delete account

**Example**:
```swift
func testTotalBalance() throws {
    // Given
    let account1 = SavingsAccount(...) // balance: 1000
    let account2 = SavingsAccount(...) // balance: 2000
    try repository.create(account1)
    try repository.create(account2)
    
    // When
    viewModel.loadAccounts()
    
    // Then
    XCTAssertEqual(viewModel.totalBalance, 3000.0)
}
```

#### AccountDetailViewModelTests

Tests account detail calculations:

**Coverage**:
- ✅ Initialization
- ✅ Annual growth calculation
- ✅ Projected balance
- ✅ Projection data generation
- ✅ Milestones calculation
- ✅ Milestone progress
- ✅ Account age formatting
- ✅ Created date formatting

## UI Tests

### SavingsOverviewUITests

End-to-end UI tests:

**Coverage**:
- ✅ App launches successfully
- ✅ Dashboard displays correctly
- ✅ Tab navigation works
- ✅ Add account flow
- ✅ Search functionality
- ✅ Account detail navigation
- ✅ Settings navigation
- ✅ Accessibility labels
- ✅ Chart existence

**Example**:
```swift
func testAddAccountFlow() throws {
    // Given
    app.navigationBars["Savings Overview"].buttons.matching(identifier: "addAccountButton").firstMatch.tap()
    
    let nameField = app.textFields["Account Name"]
    XCTAssertTrue(nameField.waitForExistence(timeout: 2))
    
    // When - Fill form
    nameField.tap()
    nameField.typeText("Test Account")
    // ... fill other fields
    
    app.navigationBars["Add Account"].buttons["Save"].tap()
    
    // Then
    XCTAssertTrue(app.staticTexts["Test Account"].waitForExistence(timeout: 2))
}
```

### AccountManagementUITests

CRUD operation tests:

**Coverage**:
- ✅ Create and delete account (full flow)
- ✅ Edit account
- ✅ Form validation (disabled save button)

## Running Tests

### In Xcode

1. **Run All Tests**: Cmd + U
2. **Run Specific Test**: Click diamond next to test
3. **Run Test Class**: Click diamond next to class
4. **Run Test Target**: Select scheme, then test

### Command Line

```bash
# Run all tests
xcodebuild test -scheme SavingsOverview -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test
xcodebuild test -scheme SavingsOverview -only-testing:SavingsOverviewTests/DashboardViewModelTests

# Run with code coverage
xcodebuild test -scheme SavingsOverview -enableCodeCoverage YES
```

## Test Principles

### 1. AAA Pattern
```swift
func testExample() {
    // Arrange (Given)
    let account = SavingsAccount(...)
    
    // Act (When)
    let result = account.projectedBalance(months: 12)
    
    // Assert (Then)
    XCTAssertEqual(result, expectedValue)
}
```

### 2. Independence
- Each test should run independently
- Use setUp() and tearDown()
- Use in-memory stores for isolation

### 3. Descriptive Names
```swift
// Good
func testProjectedBalanceTwelveMonthsReturnsCorrectValue()

// Avoid
func testProjection()
```

### 4. Single Responsibility
- Test one thing per test method
- Multiple assertions for same concept OK
- Split complex tests into multiple tests

### 5. Test Coverage Goals
- Models: 100%
- ViewModels: 90%+
- Repositories: 100%
- Utilities: 90%+
- UI: Critical paths

## Mocking and Stubbing

### In-Memory Core Data
```swift
let controller = PersistenceController(inMemory: true)
let repository = SavingsRepository(context: controller.container.viewContext)
```

### Mock Repository (Example)
```swift
class MockSavingsRepository: SavingsRepository {
    var accounts: [SavingsAccount] = []
    var shouldFail = false
    
    override func fetchAll() throws -> [SavingsAccount] {
        if shouldFail {
            throw NSError(domain: "test", code: 1)
        }
        return accounts
    }
}
```

## Accessibility Testing

UI tests verify accessibility:

```swift
func testAccessibilityLabels() {
    XCTAssertTrue(app.buttons.matching(identifier: "addAccountButton").count > 0)
    XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
}
```

## Code Coverage

### Viewing Coverage

1. Run tests with coverage enabled
2. View Report Navigator (Cmd + 9)
3. Select latest test run
4. Click Coverage tab

### Coverage Goals

| Component | Goal |
|-----------|------|
| Models | 100% |
| ViewModels | 90%+ |
| Repositories | 100% |
| Utilities | 90%+ |
| Views | N/A (use UI tests) |

## Common Test Patterns

### Testing Async Code
```swift
func testAsyncOperation() async throws {
    // Given
    let expectation = expectation(description: "completion")
    
    // When
    await viewModel.loadData()
    expectation.fulfill()
    
    // Then
    await fulfillment(of: [expectation], timeout: 2)
    XCTAssertTrue(viewModel.dataLoaded)
}
```

### Testing Published Properties
```swift
func testPublishedProperty() {
    let expectation = expectation(description: "published")
    var receivedValue: String?
    
    let cancellable = viewModel.$name
        .sink { value in
            receivedValue = value
            expectation.fulfill()
        }
    
    viewModel.name = "Test"
    
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(receivedValue, "Test")
    cancellable.cancel()
}
```

### Testing Error Handling
```swift
func testErrorHandling() {
    // Given
    let badData = "invalid"
    
    // When
    XCTAssertThrowsError(try parseData(badData)) { error in
        // Then
        XCTAssertTrue(error is ParseError)
    }
}
```

## Debugging Tests

### Print Debugging
```swift
print("Debug: value = \(value)")
```

### Breakpoints
- Set breakpoint in test
- Run test with debugger
- Inspect variables

### UI Test Recording
1. Place cursor in UI test
2. Click record button
3. Interact with app
4. Code is generated

## Continuous Integration

### Test Script
```bash
#!/bin/bash
xcodebuild test \
  -scheme SavingsOverview \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES \
  -resultBundlePath ./test-results
```

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: xcodebuild test -scheme SavingsOverview
```

## Best Practices

1. **Write Tests First**: TDD when possible
2. **Keep Tests Fast**: Use in-memory stores
3. **Test Behavior**: Not implementation details
4. **Meaningful Assertions**: Use descriptive messages
5. **Clean Up**: Always use tearDown()
6. **Test Edge Cases**: Nil, empty, boundary values
7. **Document Complex Tests**: Add comments
8. **Regular Execution**: Run tests frequently

## Test Statistics

**Total Tests**: 40+

### Unit Tests: 32+
- Model Tests: 7
- Repository Tests: 6
- Utility Tests: 12
- ViewModel Tests: 15+

### UI Tests: 11
- Navigation: 3
- CRUD Operations: 3
- Accessibility: 2
- Search: 1
- Validation: 1
- Charts: 1

## Next Steps

1. Add more ViewModel tests
2. Increase code coverage to 90%+
3. Add performance tests
4. Add snapshot tests for UI
5. Integrate with CI/CD pipeline
