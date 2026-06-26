import SwiftUI

struct NetworkMock: NetworkInterface {
    func request<T: Decodable>(responseType: T.Type, _ service: NetworkServiceInterface) async throws -> T {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        if responseType == [FeatureResponse].self {
            return await [
                FeatureResponse(title: "Item 1", subtitle: "Descrição do Item 1", iconName: "star"),
                FeatureResponse(title: "Item 2", subtitle: "Descrição do Item 2", iconName: "heart")
            ] as! T
        }
        fatalError("Unsupported response type")
    }
}

struct AnalyticsMock: AnalyticsManagerType {
    func track(event: String, parameters: [String: Any]) {
        print("Track event: \(event), parameters: \(parameters)")
    }
}

struct ObservabilityMock: ObservabilityManagerType {
    func log(message: String) {
        print("Log: \(message)")
    }
}

@main
struct MyApp: App {
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

typealias FeatureViewModelComposite = ObservableObject &
                                      FeatureViewModelType &
                                      FeatureViewModelAnalytics &
                                      FeatureViewModelObservability

// TODO: Remover generics
struct ContentView<VM: FeatureViewModelComposite>: View {
    @StateObject var viewModel: VM

    init(viewModel: @autoclosure @escaping () -> VM) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            Text("Loading")
        case .ready:
            List(viewModel.data, id: \.self) { item in
                Text(item.title)
                    .onTapGesture {
                        if let index = viewModel.data.firstIndex(of: item) {
                            viewModel.showItem(for: index)
                        }
                    }
            }
        case .error:
            Text("Erro ao carregar")
        }
    }

    var body: some View {
        content
            .task {
                await viewModel.loadData()
            }
    }
}

#Preview {
    let network = NetworkMock()
    let repository = FeatureRepository(network: network)
    let analytics = AnalyticsMock()
    let observability = ObservabilityMock()
    let router = Router<FeatureAction>()

    ContentView(
        viewModel: FeatureViewModel(
            repository: repository,
            analyticsManager: analytics,
            observabilityManager: observability,
            router: router
        )
    )
}
