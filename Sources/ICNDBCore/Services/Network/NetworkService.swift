import Foundation
import NetworkKit

public protocol NetworkService {
    var baseURL: URL { get }
    func load<ResourceType>(resource: Resource<ResourceType>, completion: @escaping (Result<ResourceType, NetworkError>) -> Void)
    func load<ResourceType>(resource: Resource<ResourceType>) async throws -> ResourceType
}

public protocol UsesNetworkService {
    var networkService: NetworkService { get }
}

public class MixInNetworkService: NetworkService {
    public let baseURL: URL
    private let networkKit: NetworkKit

    public init() {
        self.baseURL = URL(string: "http://api.icndb.com/")!
        self.networkKit = NetworkKit()
    }

    public func load<ResourceType>(resource: Resource<ResourceType>, completion: @escaping (Result<ResourceType, NetworkError>) -> Void) {
        networkKit.load(resource: resource, completion: completion)
    }

    public func load<ResourceType>(resource: Resource<ResourceType>) async throws -> ResourceType {
        try await networkKit.load(resource: resource)
    }
}
