// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// KalSae HTML-only fork: publishing layer removed, only HTML generation DSL remains.

import PackageDescription

let package = Package(
    name: "Ignite",
    platforms: [.macOS(.v13), .iOS(.v17)],
    products: [
        .library(name: "Ignite", targets: ["Ignite"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
    ],
    targets: [
        .target(
            name: "Ignite",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
    ]
)
