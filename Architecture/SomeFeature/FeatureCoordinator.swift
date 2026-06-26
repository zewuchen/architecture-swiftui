import SwiftUI

/// View coordenadora que gerencia navegação.
/// ContentView não conhece NavigationStack nem rotas.
struct FeatureCoordinator: View {
    @State private var route: FeatureAction?
    @ObservedObject var viewModel: FeatureViewModel

    private let repository: FeatureRepositoryType
    private let analyticsManager: AnalyticsManagerType
    private let observabilityManager: ObservabilityManagerType

    init(repository: FeatureRepositoryType,
         analyticsManager: AnalyticsManagerType,
         observabilityManager: ObservabilityManagerType,
         viewModel: FeatureViewModel) {
        self.repository = repository
        self.analyticsManager = analyticsManager
        self.observabilityManager = observabilityManager
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ContentView(viewModel: viewModel)
                .navigationDestination(item: $route) { action in
                    destinationView(for: action)
                }
        }
        .onAppear {
            viewModel.onNavigate = { action in
                self.route = action
            }
        }
    }

    @ViewBuilder
    private func destinationView(for action: FeatureAction) -> some View {
        switch action {
        case .openScreen1:
            let viewModel = FeatureViewModel1(repository: repository,
                                              analyticsManager: analyticsManager,
                                              observabilityManager: observabilityManager)
            ScreenView1(viewModel: viewModel)
        case .openScreen2:
            let viewModel = FeatureViewModel2(repository: repository,
                                              analyticsManager: analyticsManager,
                                              observabilityManager: observabilityManager)
            ScreenView2(viewModel: viewModel)
        }
    }
}
