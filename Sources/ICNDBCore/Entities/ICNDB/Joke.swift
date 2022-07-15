import Foundation
import NetworkKit

public struct Jokes: Decodable, Equatable {
    let type: String
    let value: [Joke]
}

public struct Joke: Decodable, Equatable {
    let identifier: Int
    let joke: String
    let categories: [Category]
}

extension Joke {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case joke
        case categories
    }
}

// MARK: Resource for Joke

public extension Jokes {
    static func resource() -> Resource<Jokes> {
        let request = RequestBuilder(url: URL(string: "https://api.icndb.com/jokes/random/1")!).build()
        return Resource<Jokes>(request: request) { data in
            try? JSONDecoder().decode(Jokes.self, from: data)
        }
    }
}
