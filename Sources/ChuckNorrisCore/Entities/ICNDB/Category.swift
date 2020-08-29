import Foundation
import NetworkKit

public struct Category: Codable, Equatable {
    let names: [String]
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case names = "value"
    }
}

// MARK: Resource for Joke

extension Category {
    public static func resource() -> Resource<Category> {
        let request = RequestBuilder(url: URL(string: "https://api.icndb.com/categories")!).build()
        return Resource<Category>(request: request) { data in
            return try? JSONDecoder().decode(Category.self, from: data)
        }
    }
}
