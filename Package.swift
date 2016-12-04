import PackageDescription

let package = Package(
    name: "ICNDB",
    targets: [
        Target(name: "CLI", dependencies: [.Target(name:"App")])
    ],
    dependencies: [
        .Package(url: "https://github.com/eelcokoelewijn/NetworkKit.git", "1.0.5"),
    ]
)
