import Foundation
import NetworkKit

public protocol ICNDBService: UsesNetworkService {
    @available(macOS 10.15, *)
    func getRandomJoke(
        substituteFirstname firstName: String?,
        substituteLastname lastName: String?,
        numberOfJokes number: Int,
        completion: @escaping ([String]) throws -> Void
    )
    @available(macOS 10.15, *)
    func getRandomJoke(
        substituteFirstname firstName: String?,
        substituteLastname lastName: String?,
        numberOfJokes number: Int
    ) async throws -> [String]
    @available(macOS 10.15, *)
    func getJokeCategories(completion: @escaping ([String]) throws -> Void)
    @available(macOS 10.15, *)
    func getJokeCategories() async throws -> [String]
}

public protocol UsesICNDBService {
    var icndbService: ICNDBService { get }
}

public class MixInICNDBService: ICNDBService {
    public let networkService: NetworkService

    public init() {
        self.networkService = MixInNetworkService()
    }

    @available(macOS 10.15, *)
    public func getRandomJoke(
        substituteFirstname firstName: String? = nil,
        substituteLastname lastName: String? = nil,
        numberOfJokes number: Int = 1,
        completion: @escaping ([String]) throws -> Void
    ) {
        let resource = getRandomJokeResource(firstName: firstName, lastName: lastName, numberOfJokes: number)
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

    @available(macOS 10.15, *)
    public func getRandomJoke(
        substituteFirstname firstName: String? = nil,
        substituteLastname lastName: String? = nil,
        numberOfJokes number: Int = 1
    ) async throws -> [String] {
        let resource = getRandomJokeResource(firstName: firstName, lastName: lastName, numberOfJokes: number)
        let jokes = try await networkService.load(resource: resource)
        return jokes.value.map { randomJokes in randomJokes.joke.htmlDecode() }
    }

    @available(macOS 10.15, *)
    public func getJokeCategories(completion: @escaping ([String]) throws -> Void) {
        let resource = getCategoriesResource()
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
    
    @available(macOS 10.15, *)
    public func getJokeCategories() async throws -> [String] {
        let resource = getCategoriesResource()
        let category = try await networkService.load(resource: resource)
        return category.names
    }

    private func getRandomJokeResource(firstName: String? = nil, lastName: String? = nil, numberOfJokes number: Int = 1) -> Resource<Jokes> {
        let url = networkService.baseURL.appendingPathComponent("jokes/random/\(number)")
        var params: [String: String] = [:]
        if let firstName = firstName, let lastName = lastName {
            params["firstName"] = firstName
            params["lastName"] = lastName
        }
        let request = RequestBuilder(url: url).parameters(params).build()
        let resource = Resource<Jokes>(request: request, parseResponse: { data in
            try? JSONDecoder().decode(Jokes.self, from: data)
        })
        return resource
    }

    private func getCategoriesResource() -> Resource<Category> {
        let url = networkService.baseURL.appendingPathComponent("categories")
        let request = RequestBuilder(url: url).build()
        let resource = Resource<Category>(request: request) { data in
            try? JSONDecoder().decode(Category.self, from: data)
        }
        return resource
    }
}
