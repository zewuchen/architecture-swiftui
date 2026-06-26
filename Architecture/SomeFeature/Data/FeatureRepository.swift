import Foundation
//import Network

// Função do SDK da network
protocol NetworkInterface {
    func request<T: Decodable>(responseType: T.Type, _ service: NetworkServiceInterface) async throws -> T
}

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
