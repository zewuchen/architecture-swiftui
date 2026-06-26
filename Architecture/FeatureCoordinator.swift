import SwiftUI

/// View coordenadora que gerencia navegação.
/// ContentView não conhece NavigationStack nem rotas.
/// Responsável por gerenciar a transição de telas de uma mesma feature. Várias pastas SomeFeature OU um novo fluxo chamando outro Coordinator
struct FeatureCoordinator: View {
    @ObservedObject var router: Router<FeatureAction>

    private let repository: FeatureRepositoryType
    private let analyticsManager: AnalyticsManagerType
    private let observabilityManager: ObservabilityManagerType

    init(router: Router<FeatureAction>,
         repository: FeatureRepositoryType,
         analyticsManager: AnalyticsManagerType,
         observabilityManager: ObservabilityManagerType) {
        self.router = router
        self.repository = repository
        self.analyticsManager = analyticsManager
        self.observabilityManager = observabilityManager
    }

    var body: some View {
        NavigationStack {
            FeatureView(viewModel: FeatureViewModel(repository: repository,
                                                    analyticsManager: analyticsManager,
                                                    observabilityManager: observabilityManager,
                                                    router: router))
                .navigationDestination(item: $router.route) { action in
                    destinationView(for: action)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for action: FeatureAction) -> some View {
        switch action {
        case .openScreen1:
            // Não instanciar em uma variavel, as Views utilizarão @autoclousure e o compilador entenderá de forma diferente
            // let viewModel = FeatureViewModel1(repository: repository,
            //                                   analyticsManager: analyticsManager,
            //                                   observabilityManager: observabilityManager,
            //                                   router: router)
            // ScreenView1(viewModel: viewModel)
            Text("Screen 1") // Dummy code to compile
        case .openScreen2:
            // Modo certo
            // let viewModel = FeatureViewModel2(repository: repository,
            //                                   analyticsManager: analyticsManager,
            //                                   observabilityManager: observabilityManager,
            //                                   router: router)
            // ScreenView2(viewModel: viewModel)
            Text("Screen 2") // Dummy code to compile
        }
    }
}
