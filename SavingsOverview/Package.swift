// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SavingsOverview",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SavingsOverview", targets: ["SavingsOverview"])
    ],
    targets: [
        // Keep SPM target simple and do NOT include the .xcdatamodeld resource
        .target(
            name: "SavingsOverview",
            path: ".",
            exclude: [
                "Persistence/SavingsDataModel.xcdatamodeld",
                "Tests",
                "UITests",
                "Info.plist",
                "Assets",
                "README.md",
                "SETUP_GUIDE.md",
                "MVVM_GUIDE.md",
                "IMPLEMENTATION_CHECKLIST.md",
                "PRODUCTION_READINESS.md",
                "CODE_REVIEW_FINDINGS.md",
                "TESTING_GUIDE.md",
                "IGNORE_PACKAGE.md",
                "PROJECT_COMPLETION_SUMMARY.md"
            ]
        ),
        .testTarget(
            name: "SavingsOverviewTests",
            dependencies: ["SavingsOverview"],
            path: "Tests"
        )
    ]
)
