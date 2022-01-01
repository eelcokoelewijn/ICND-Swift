import Foundation
import NetworkKit

public protocol NetworkService {
    var baseURL: URL { get }
    func load<ResourceType>(resource: Resource<ResourceType>,
                            completion: @escaping (Result<ResourceType, NetworkError>) -> Void)
}

public protocol UsesNetworkService {
    var networkService: NetworkService { get }
}

public class MixInNetworkService: NetworkService {
    public let baseURL: URL
    private let networkKit: NetworkKit

    public init() {
        baseURL = URL(string: "https://api.icndb.com/")!
        networkKit = NetworkKit()
    }

    public func load<ResourceType>(resource: Resource<ResourceType>,
                                   completion: @escaping (Result<ResourceType, NetworkError>) -> Void) {
        networkKit.load(resource: resource, completion: completion)
    }
}
