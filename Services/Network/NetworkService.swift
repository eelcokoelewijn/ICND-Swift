import Foundation
import NetworkKit

protocol NetworkService {
    var baseURL: URL { get }
    func load<ResourceType>(resource: Resource<ResourceType>,
              completion: @escaping (Result<ResourceType>) -> ())
}

protocol UsesNetworkService {
    var networkService: NetworkService { get }
}

class MixInNetworkService: NetworkService {
    internal let baseURL: URL
    private let networkKit: NetworkKit
    
    init() {
        baseURL = URL(string: "https://api.icndb.com/")!
        networkKit = NetworkKit()
    }
    
    func load<ResourceType>(resource: Resource<ResourceType>,
              completion: @escaping (Result<ResourceType>) -> ()) {
        networkKit.load(resource: resource, completion: completion)
    }
}
