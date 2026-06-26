import SwiftUI

struct NetworkMock: NetworkInterface {
    func request<T: Decodable>(responseType: T.Type, _ service: NetworkServiceInterface) async throws -> T {
        if responseType == [FeatureResponse].self {
            return [
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
                observabilityManager: Self.observability,
                viewModel: viewModel
            )
        }
    }
}

private typealias FeatureViewModelType = ObservableObject & FeatureViewModel & FeatureViewModelAnalyticsType & FeatureViewModelObservability

struct ContentView: View {
    @StateObject var viewModel: FeatureViewModel

    init(viewModel: @autoclosure @escaping () -> FeatureViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                Text("Loading")
            case .ready:
                List(viewModel.data.indices, id: \.self) { index in
                    Text(viewModel.data[index].title)
                        .onTapGesture {
                            viewModel.showItem(for: index)
                        }
                }
            case .error:
                Text("Erro ao carregar")
            }
        }
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
