import PackageDescription

let package = Package(
    name: "JokesByChuckNorris",
    dependencies: [
        .Package(url: "https://github.com/eelcokoelewijn/NetworkKit.git", "1.0.5"),
    ]
)
