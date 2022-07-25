// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwarmChemistry Build Tools",
    dependencies: [
         .package(url: "https://github.com/realm/SwiftLint.git", from: "0.47.1"),
    ],
    targets: [
        .target(
            name: "BuildTools",
            dependencies: []),
    ]
)
