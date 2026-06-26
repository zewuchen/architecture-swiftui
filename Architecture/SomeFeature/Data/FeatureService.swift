import Foundation
//import Network

// Funções da camada de rede, apenas exemplo
enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol NetworkServiceInterface {
    var path: String { get set }
    var method: HttpMethod { get set }
    var headerParams: Encodable? { get set }
    var body: Encodable? { get set }
}

// Exemplo de estrutura de requisição por endpoint / serviço
struct FeatureService: NetworkServiceInterface {
    var path: String = "/endpoint"

    var method: HttpMethod = .get

    var headerParams: Encodable?

    var body: Encodable?
}
