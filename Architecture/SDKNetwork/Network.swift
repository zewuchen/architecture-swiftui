import Foundation

enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol NetworkInterface {
    func request<T: Decodable>(responseType: T.Type, _ service: NetworkServiceInterface) async throws -> T
}

protocol NetworkServiceInterface {
    var path: String { get set }
    var method: HttpMethod { get set }
    var headerParams: Encodable? { get set }
    var body: Encodable? { get set }
}

struct NetworkMock: NetworkInterface {
    func request<T: Decodable>(responseType: T.Type, _ service: NetworkServiceInterface) async throws -> T {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        if responseType == [FeatureResponse].self {
            return await [
                FeatureResponse(title: "Item 1", subtitle: "Descrição do Item 1", iconName: "star"),
                FeatureResponse(title: "Item 2", subtitle: "Descrição do Item 2", iconName: "heart")
            ] as! T
        }
        fatalError("Unsupported response type")
    }
}
