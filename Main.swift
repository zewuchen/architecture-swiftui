import SwiftUI

@main
struct Main: App {
    private static let network = NetworkMock()
    private static let repository = FeatureRepository(network: network)
    private static let analytics = AnalyticsMock()
    private static let observability = ObservabilityMock()

    @StateObject private var router = Router<FeatureAction>()
    @StateObject private var viewModel: FeatureViewModel

    init() {
        let router = Router<FeatureAction>()
        self._router = StateObject(wrappedValue: router)
        self._viewModel = StateObject(wrappedValue: FeatureViewModel(
            repository: Self.repository,
            analyticsManager: Self.analytics,
            observabilityManager: Self.observability,
            router: router
        ))
    }

    var body: some Scene {
        WindowGroup {
            FeatureCoordinator(
                router: router,
                repository: Self.repository,
                analyticsManager: Self.analytics,
                observabilityManager: Self.observability
            )
        }
    }
}
