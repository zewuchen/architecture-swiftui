import Foundation
// import Analytics
// import Observability

// Função de analytics do SDK
protocol AnalyticsManagerType {
    func track(event: String, parameters: [String: Any])
}

// Função de observability do SDK
protocol ObservabilityManagerType {
    func log(message: String)
}

protocol FeatureViewModelType: AnyObject {
    func loadData() async
    func showItem(for index: Int)
}

protocol FeatureViewModelAnalyticsType: AnyObject {
    func trackScreenView()
    func trackClickItem(title: String)
}

protocol FeatureViewModelObservability: AnyObject {
    func log(message: String)
}

// Classe responsável pela regra de negócio e atualização da view
final class FeatureViewModel: ObservableObject {

    // MARK: - Private properties
    private let repository: FeatureRepositoryType
    private let analyticsManager: AnalyticsManagerType
    private let observabilityManager: ObservabilityManagerType
    private let router: Router<FeatureAction>

    @Published
    var state: FeatureViewState = .loading

    @Published
    var data: [FeatureViewDTO] = []

    // MARK: - Internal functions
    init(repository: FeatureRepositoryType,
         analyticsManager: AnalyticsManagerType,
         observabilityManager: ObservabilityManagerType,
         router: Router<FeatureAction>) {
        self.repository = repository
        self.analyticsManager = analyticsManager
        self.observabilityManager = observabilityManager
        self.router = router
    }

    // MARK: - Private functions
    private func handleSuccessRequest(response: [FeatureResponse]) {
        data = response.enumerated().compactMap { index, item in
            let title = item.title
            let description = item.subtitle
            let hasBorder = index == 0
            let iconName = item.iconName
            let action: FeatureAction = (index % 2 == 0) ? .openScreen1 : .openScreen2

            return FeatureViewDTO(title: title,
                                  description: description,
                                  hasBorder: hasBorder,
                                  iconName: iconName,
                                  action: action)
        }

        state = .ready
    }
}

// MARK: - FeatureViewModelType
extension FeatureViewModel: FeatureViewModelType {
    func loadData() async {
        state = .loading
        do {
            let response = try await repository.getList()
            handleSuccessRequest(response: response)
        } catch {
            state = .error
            log(message: "Error to load data: \(error.localizedDescription)")
        }
    }

    func showItem(for index: Int) {
        guard index >= 0 && index < data.count else {
            state = .error
            log(message: "Error to find item at index: \(index)")
            return
        }

        let item = data[index]
        router.navigate(to: item.action)
    }
}

// MARK: - FeatureViewModelAnalyticsType
extension FeatureViewModel: FeatureViewModelAnalyticsType {
    func trackScreenView() {
        analyticsManager.track(event: "screen_view", parameters: FeatureAnalyticsEvents.screenView.parameters() ?? [:])
    }

    func trackClickItem(title: String) {
        analyticsManager.track(event: "click", parameters: FeatureAnalyticsEvents.tapItem(title: title).parameters() ?? [:])
    }
}

// MARK: - FeatureViewModelObservability
extension FeatureViewModel: FeatureViewModelObservability {
    func log(message: String) {
        observabilityManager.log(message: message)
    }
}