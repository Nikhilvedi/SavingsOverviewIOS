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
            sources: [
                "Models",
                "Views",
                "Utilities",
                "Persistence"
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
