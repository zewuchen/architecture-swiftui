import SwiftUI

// Classe responsável pela navegação, cada T é um enum de rotas de cada coordinator. Não é necessário criar varias classes Router
public final class Router<T>: ObservableObject {

    public init() { }

    @Published public var route: T?

    public func navigate(to route: T) {
        self.route = route
    }

    public func pop() {
        self.route = nil
    }
}
