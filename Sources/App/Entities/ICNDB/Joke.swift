import Foundation
import NetworkKit

public struct Joke {
    let identifier: Int
    let description: String
}

// MARK: Parse json response to Joke struct

extension Joke {
    public init(json: JSONDictionary) throws {
        guard let identifier = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }

        guard let description = json["joke"] as? String else {
            throw SerializationError.missing("joke")
        }

        self.identifier = identifier
        self.description = description
    }
}

// MARK: Resource for Joke

extension Joke {
    public static func resource() -> Resource<Joke> {
        let request = Request(url: URL(string: "https://api.icndb.com/jokes/random")!)
        return Resource<Joke>(request: request) { json in
            guard let dic = json as? JSONDictionary else { return nil }
            guard let jokeJSON = dic["value"] as? JSONDictionary else { return nil }
            return try? Joke.init(json: jokeJSON)
        }
    }
}
