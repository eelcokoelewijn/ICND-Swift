import PackageDescription

let package = Package(
    name: "JokesByChuckNorris",
    dependencies: [
        .Package(url: "../NetworkKit", "1.0.2"),
    ]
)
