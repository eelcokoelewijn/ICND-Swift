// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ICNDB",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "icndb", targets: ["ICNDB"]),
        .library(
            name: "ICNDBCore",
            targets: ["ICNDBCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/eelcokoelewijn/NetworkKit", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ICNDB",
            dependencies: ["ICNDBCore",
                           .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(name: "ICNDBCore",
                dependencies: ["NetworkKit"]),
        .testTarget(
            name: "ICNDBTests",
            dependencies: ["ICNDB"]),
    ]
)
