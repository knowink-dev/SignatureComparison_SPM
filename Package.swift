// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SignatureComparison",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SignatureComparison",
            targets: ["SignatureComparison"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SignatureComparison",
            dependencies: [],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "SignatureComparisonTests",
            dependencies: ["SignatureComparison"]),
    ]
)
