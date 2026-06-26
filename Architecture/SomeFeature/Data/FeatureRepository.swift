import Foundation
//import Network

protocol FeatureRepositoryType {
    func getList() async throws -> [FeatureResponse]
}

final class FeatureRepository {
    private let network: NetworkInterface

    init(network: NetworkInterface) {
        self.network = network
    }
}

extension FeatureRepository: FeatureRepositoryType {
    func getList() async throws -> [FeatureResponse] {
        let service = FeatureService()

        return try await network.request(responseType: [FeatureResponse].self,
                                         service)
    }
}
