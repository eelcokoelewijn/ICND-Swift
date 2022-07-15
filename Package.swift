// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ICNDB",
    products: [
        .executable(name: "icndb", targets: ["ICNDB"]),
        .library(name: "ICNDBCore", targets: ["ICNDBCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/eelcokoelewijn/NetworkKit", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.35.8")
    ],
    targets: [
        .executableTarget(
            name: "ICNDB",
            dependencies: [
                "ICNDBCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(name: "ICNDBCore", dependencies: ["NetworkKit"]),
        .testTarget(name: "ICNDBTests", dependencies: ["ICNDB"])
    ]
)
