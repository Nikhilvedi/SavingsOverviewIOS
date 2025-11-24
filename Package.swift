// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SavingsOverview",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SavingsOverview",
            targets: ["SavingsOverview"]),
    ],
    targets: [
        .target(
            name: "SavingsOverview",
            dependencies: [],
            path: "SavingsOverview",
            exclude: [
                "Assets",
                "CODE_REVIEW_FINDINGS.md",
                "IGNORE_PACKAGE.md",
                "IMPLEMENTATION_CHECKLIST.md",
                "Info.plist",
                "MVVM_GUIDE.md",
                "PRODUCTION_READINESS.md",
                "PROJECT_COMPLETION_SUMMARY.md",
                "README.md",
                "SavingsOverviewApp.swift",
                "SETUP_GUIDE.md",
                "TESTING_GUIDE.md",
                "Tests",
                "UITests"
            ],
            resources: [
                .process("Persistence/SavingsDataModel.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "SavingsOverviewTests",
            dependencies: ["SavingsOverview"],
            path: "SavingsOverview/Tests"
        )
    ]
)
