import Foundation
import NetworkKit

public protocol ICNDBService: UsesNetworkService {
    func getRandomJoke(substituteFirstname firstName: String?,
                       substituteLastname lastName: String?,
                       numberOfJokes number: Int,
                       completion: @escaping ([String]) throws -> Void)
    func getJokeCategories(completion: @escaping ([String]) throws -> Void)
}

public protocol UsesICNDBService {
    var icndbService: ICNDBService { get }
}

public class MixInICNDBService: ICNDBService {
    public let networkService: NetworkService

    public init() {
        networkService = MixInNetworkService()
    }

    public func getRandomJoke(substituteFirstname firstName: String? = nil,
                              substituteLastname lastName: String? = nil,
                              numberOfJokes number: Int = 1,
                              completion: @escaping ([String])  throws -> Void) {
        let url = networkService.baseURL.appendingPathComponent("jokes/random/\(number)")
        var params: [String: String] = [:]
        if let firstName = firstName, let lastName = lastName {
            params["firstName"] = firstName
            params["lastName"] = lastName
        }
        let request = RequestBuilder(url: url).parameters(params).build()
        let resource = Resource<Jokes>(request: request, parseResponse: { data in
            return try? JSONDecoder().decode(Jokes.self, from: data)
        })
        let semaphore = DispatchSemaphore(value: 0)
        networkService.load(resource: resource) { result in
            defer {
                semaphore.signal()
            }
            guard case let .success(jokes) = result else { return }
            let texts: [String] = jokes.value.map { randomJokes in randomJokes.joke.htmlDecode() }
            try? completion(texts)
        }
        semaphore.wait()
    }

    public func getJokeCategories(completion: @escaping ([String]) throws -> Void) {
        let url = networkService.baseURL.appendingPathComponent("categories")
        let request = RequestBuilder(url: url).build()
        let resource = Resource<Category>(request: request) { data in
            return try? JSONDecoder().decode(Category.self, from: data)
        }
        let semaphore = DispatchSemaphore(value: 0)
        networkService.load(resource: resource) { result in
            defer {
                semaphore.signal()
            }
            guard case let .success(category) = result else { return }
            try? completion(category.names)
        }
        semaphore.wait()
    }
}
