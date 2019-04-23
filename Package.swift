// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JokesByChuckNorris",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "jokes", targets: ["JokesByChuckNorris"]),
        .library(
            name: "ChuckNorrisCore",
            targets: ["ChuckNorrisCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        Package.Dependency.package(url: "https://github.com/eelcokoelewijn/NetworkKit", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "JokesByChuckNorris",
            dependencies: ["ChuckNorrisCore"]),
        .target(name: "ChuckNorrisCore",
                dependencies: ["NetworkKit"]),
        .testTarget(
            name: "JokesByChuckNorrisTests",
            dependencies: ["JokesByChuckNorris"]),
    ]
)