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
    var path: String
    var method: HttpMethod
    var headerParams: Encodable?
    var body: Encodable?
}

// Exemplo de estrutura de requisição por endpoint / serviço
struct FeatureService: NetworkServiceInterface {
    var path: String = "/endpoint"

    var method: HttpMethod = .get

    var headerParams: Encodable?

    var body: Encodable?
}
