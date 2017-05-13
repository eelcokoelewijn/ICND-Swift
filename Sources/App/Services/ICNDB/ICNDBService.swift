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
        let resource = Resource<Joke>(request: request, parseResponse: { json in
            guard let dic = json as? JSONDictionary else { return nil }
            guard let joke = dic["value"] as? JSONDictionary else { return nil }
            return try? Joke.init(json: joke)
        })
        networkService.load(resource: resource) { r in
            guard case let .success(joke) = r else { return }
            completion(joke.description.htmlDecode())
        }
    }

    public func getRandom(numberOfJokes number: Int, completion: @escaping ([String]) -> Void) {
        let url = networkService.baseURL.appendingPathComponent("jokes/random/\(number)")
        let request = Request(url: url)
        let resource = Resource<[Joke]>(request: request) { json in
            guard let dic = json as? JSONDictionary else { return nil}
            guard let jokes = dic["value"] as? [JSONDictionary] else { return nil }
            return jokes.flatMap({ item in
                return try? Joke.init(json: item)
            })
        }
        networkService.load(resource: resource) { r in
            guard case let .success(jokes) = r else { return }
            let texts: [String] = jokes.map { joke in joke.description.htmlDecode() }
            completion(texts)
        }
    }

    public func getJokeCategories(completion: @escaping ([String]) -> Void) {
        let url = networkService.baseURL.appendingPathComponent("categories")
        let request = Request(url: url)
        let resource = Resource<[String]>(request: request) { json in
            guard let dic = json as? JSONDictionary else { return nil}
            guard let categories = dic["value"] as? [String] else { return nil }
            return categories.flatMap({ item in
                return String.init(describing: item)
            })
        }
        networkService.load(resource: resource) { r in
            guard case let .success(categories) = r else { return }
            completion(categories)
        }
    }
}
