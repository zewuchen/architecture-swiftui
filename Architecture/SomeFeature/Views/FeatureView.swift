import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            FeatureCoordinatorView()
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
    ContentView()
}
