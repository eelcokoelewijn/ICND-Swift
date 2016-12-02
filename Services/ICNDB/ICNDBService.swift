import Foundation
import NetworkKit

protocol ICNDBService: UsesNetworkService {
    func getRandomJoke(substituteFirstname firstName: String?,
                       substituteLastname lastName: String?,
                       completion: @escaping (String) -> ())
    func getRandom(numberOfJokes number: Int, completion: @escaping ([String]) -> ())
    func getJokeCategories(completion: @escaping ([String])->())
}

protocol UsesICNDBService {
    var icndbService: ICNDBService { get }
}

class MixInICNDBService: ICNDBService {
    internal let networkService: NetworkService
    
    init() {
        networkService = MixInNetworkService()
    }
    
    func getRandomJoke(substituteFirstname firstName: String? = nil,
                       substituteLastname lastName: String? = nil,
                       completion: @escaping ((String) -> ()) ) {
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
            guard case let .Success(ojoke) = r else { return }
            guard let joke = ojoke else { return }
            completion(joke.description.htmlDecode())
        }
    }
    
    func getRandom(numberOfJokes number: Int, completion: @escaping ([String]) -> ()) {
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
            guard case let .Success(ojokes) = r else { return }
            guard let jokes = ojokes else { return }
            let texts: [String] = jokes.map { joke in joke.description.htmlDecode() }
            completion(texts)
        }
    }
    
    func getJokeCategories(completion: @escaping ([String]) -> ()) {
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
            guard case let .Success(ocategories) = r else { return }
            guard let categories = ocategories else { return }
            completion(categories)
        }
    }
}
