import SwiftUI

@main
struct Main: App {
    private static let network = NetworkMock()
    private static let repository = FeatureRepository(network: network)
    private static let analytics = AnalyticsMock()
    private static let observability = ObservabilityMock()

    var body: some Scene {
        WindowGroup {
            FeatureCoordinator(
                repository: Self.repository,
                analyticsManager: Self.analytics,
                observabilityManager: Self.observability,
                router: Router<FeatureAction>()
            )
        }
    }
}
