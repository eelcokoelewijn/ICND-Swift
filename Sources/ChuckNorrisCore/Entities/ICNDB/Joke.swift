import Foundation
import NetworkKit

public struct Joke: Codable, Equatable {
    let identifier: Int
    let joke: String
    let type: String
}

extension Joke {
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    enum JokeCodingKeys: String, CodingKey {
        case identifier = "id"
        case joke
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        let jokeContainer = try values.nestedContainer(keyedBy: JokeCodingKeys.self, forKey: .value)
        identifier = try jokeContainer.decode(Int.self, forKey: .identifier)
        joke = try jokeContainer.decode(String.self, forKey: .joke)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        var jokeContainer = container.nestedContainer(keyedBy: JokeCodingKeys.self, forKey: .value)
        try jokeContainer.encode(identifier, forKey: .identifier)
        try jokeContainer.encode(joke, forKey: .joke)
    }
}

// MARK: Resource for Joke

extension Joke {
    public static func resource() -> Resource<Joke> {
        let request = RequestBuilder(url: URL(string: "https://api.icndb.com/jokes/random")!).build()
        return Resource<Joke>(request: request) { data in
            return try? JSONDecoder().decode(Joke.self, from: data)
        }
    }
}
