import Foundation
import NetworkKit

struct Joke {
    let id: Int
    let description: String
}

//MARK: Parse json response to Joke struct

extension Joke {
    init(json: JSONDictionary) throws {
        guard let joke = json["value"] as? JSONDictionary else {
            throw SerializationError.missing("value")
        }
    
        guard let id = joke["id"] as? Int else {
            throw SerializationError.missing("id")
        }
    
        guard let description = joke["joke"] as? String else {
            throw SerializationError.missing("joke")
        }
    
        self.id = id
        self.description = description
    }
}

//MARK: Resource for Joke

extension Joke {
    static func resource() -> Resource<Joke> {
        let request = Request(url: URL(string: "https://api.icndb.com/jokes/random")!)
        return Resource<Joke>(request: request) { json in
            guard let dic = json as? JSONDictionary else { return nil }
            return try? Joke.init(json: dic)
        }
    }
}
