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
    var body: some Scene {
        WindowGroup {
            FeatureCoordinator(
                repository: FeatureRepository(network: NetworkMock()),
                analyticsManager: AnalyticsMock(),
                observabilityManager: ObservabilityMock()
            )
        }
    }
}

private typealias FeatureViewModelType = FeatureViewModel & FeatureViewModelAnalyticsType & FeatureViewModelObservability

struct ContentView: View {
    @ObservedObject var viewModel: FeatureViewModel

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
    ContentView(
        viewModel: FeatureViewModel(
            repository: FeatureRepository(network: NetworkMock()),
            analyticsManager: AnalyticsMock(),
            observabilityManager: ObservabilityMock()
        )
    )
}
