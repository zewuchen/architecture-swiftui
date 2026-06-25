import SwiftUI

/// View coordenadora que gerencia navegação.
/// ContentView não conhece NavigationStack nem rotas.
struct FeatureCoordinator: View {
    @State private var route: FeatureAction?

    var body: some View {
        NavigationStack {
            ContentView(viewModel: viewModel)
                .navigationDestination(item: $route) { action in
                    destinationView(for: action)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for action: FeatureAction) -> some View {
        switch action {
        case .openScreen1:
            Text("Screen 1") // Substituir pela View real
        case .openScreen2:
            Text("Screen 2") // Substituir pela View real
        }
    }
}
