import Foundation
//import Network

// Exemplo de estrutura de requisição por endpoint / serviço
struct FeatureService: NetworkServiceInterface {
    var path: String = "/endpoint"

    var method: HttpMethod = .get

    var headerParams: Encodable?

    var body: Encodable?
}
