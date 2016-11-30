import Foundation
import NetworkKit

protocol ICNDBService: UsesNetworkService {
    func getRandomJoke(completion: @escaping (String) -> ())
}

protocol UsesICNDBService {
    var icndbService: ICNDBService { get }
}

class MixInICNDBService: ICNDBService {
    internal let networkService: NetworkService
    
    init() {
        networkService = MixInNetworkService()
    }
    
    func getRandomJoke(completion: @escaping ((String) -> ()) ) {
        let request = Request(url: networkService.baseURL)
        let resource = Resource<Joke>(request: request, parseResponse: { json in
            guard let dic = json as? JSONDictionary else { return nil }
            return try? Joke.init(json: dic)
        })
        networkService.load(resource: resource) { (joke, error) in
            guard let joke = joke else { return }
            completion(joke.description.htmlDecode())
        }
    }
}
