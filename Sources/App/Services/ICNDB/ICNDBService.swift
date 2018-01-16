import Foundation
import NetworkKit

public protocol ICNDBService: UsesNetworkService {
    func getRandomJoke(substituteFirstname firstName: String?,
                       substituteLastname lastName: String?,
                       completion: @escaping (String) -> Void)
    func getRandom(numberOfJokes number: Int, completion: @escaping ([String]) -> Void)
    func getJokeCategories(completion: @escaping ([String]) -> Void)
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
                              completion: @escaping ((String) -> Void) ) {
        let url = networkService.baseURL.appendingPathComponent("jokes/random")
        var params: [String: String] = [:]
        if let firstName = firstName, let lastName = lastName {
            params["firstName"] = firstName
            params["lastName"] = lastName
        }
        let request = Request(url: url, params: params)
        let resource = Resource<Joke>(request: request, parseResponse: { data in
            return try? JSONDecoder().decode(Joke.self, from: data)
        })
        networkService.load(resource: resource) { result in
            guard case let .success(randomJoke) = result else { return }
            completion(randomJoke.joke.htmlDecode())
        }
    }

    public func getRandom(numberOfJokes number: Int, completion: @escaping ([String]) -> Void) {
        let url = networkService.baseURL.appendingPathComponent("jokes/random/\(number)")
        let request = Request(url: url)
        let resource = Resource<[Joke]>(request: request) { data in
            return try? JSONDecoder().decode([Joke].self, from: data)
        }
        networkService.load(resource: resource) { result in
            guard case let .success(jokes) = result else { return }
            let texts: [String] = jokes.map { randomJokes in randomJokes.joke.htmlDecode() }
            completion(texts)
        }
    }

    public func getJokeCategories(completion: @escaping ([String]) -> Void) {
        let url = networkService.baseURL.appendingPathComponent("categories")
        let request = Request(url: url)
        let resource = Resource<[String]>(request: request) { data in
            return try? JSONDecoder().decode([String].self, from: data)
        }
        networkService.load(resource: resource) { result in
            guard case let .success(categories) = result else { return }
            completion(categories)
        }
    }
}
