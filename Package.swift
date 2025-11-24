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
                "Tests",
                "UITests",
                "Info.plist",
                "Assets",
                "Persistence/SavingsDataModel.xcdatamodeld",
                "CODE_REVIEW_FINDINGS.md",
                "IMPLEMENTATION_CHECKLIST.md",
                "TESTING_GUIDE.md",
                "PRODUCTION_READINESS.md",
                "README.md",
                "SETUP_GUIDE.md",
                "IGNORE_PACKAGE.md",
                "PROJECT_COMPLETION_SUMMARY.md",
                "MVVM_GUIDE.md",
                "SavingsOverviewApp.swift"
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
