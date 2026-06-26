import SwiftUI

typealias FeatureViewModelComposite = ObservableObject &
                                      FeatureViewModelType &
                                      FeatureViewModelAnalytics &
                                      FeatureViewModelObservability

struct FeatureView<VM: FeatureViewModelComposite>: View {
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

    FeatureView(
        viewModel: FeatureViewModel(
            repository: repository,
            analyticsManager: analytics,
            observabilityManager: observability,
            router: router
        )
    )
}
