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
            // exclude the Core Data model to avoid SPM duplicate resource rules
            exclude: ["Persistence/SavingsDataModel.xcdatamodeld"]
        ),
        .testTarget(
            name: "SavingsOverviewTests",
            dependencies: ["SavingsOverview"],
            path: "Tests"
        )
    ]
)
