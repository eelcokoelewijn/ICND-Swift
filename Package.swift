import PackageDescription

let package = Package(
    name: "JokesByChuckNorris",
    targets: [
        Target(name: "Services", dependencies: [.Target(name:"Entities")]),
    ],
    dependencies: [
        .Package(url: "https://github.com/eelcokoelewijn/NetworkKit.git", "1.0.5"),
    ]
)
