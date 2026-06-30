import Combine

public protocol RouterProtocol<Route>: AnyObject {
    associatedtype Route
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}
// Classe responsável pela navegação, cada T é um enum de rotas de cada coordinator. Não é necessário criar varias classes Router
public final class Router<T: Hashable>: ObservableObject, RouterProtocol {

    public init() { }

    @Published
    public var path: [T] = []
}

public extension Router: RouterProtocol {
    public func navigate(to route: T) {
        path.append(route)
    }

    public func pop() {
        path.removeLast()
    }

    public func popToRoot() {
        path.removeAll()
    }
}
