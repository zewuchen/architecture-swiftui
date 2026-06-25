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
    func loadData()
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
@ObservableObject
final class FeatureViewModel {

    // MARK: - Private properties
    private lazy var viewData: [FeatureViewDTO] = []
    private let repository: FeatureRepositoryType
    private let analyticsManager: AnalyticsManagerType
    private let observabilityManager: ObservabilityManagerType

    @Published
    var state: FeatureViewState = .loading

    @Published
    var data: [FeatureViewDTO] = []

    @Binding
    private var route: FeatureAction?

    // MARK: - Internal functions
    init(repository: FeatureRepositoryType,
         analyticsManager: AnalyticsManagerType,
         observabilityManager: ObservabilityManagerType,
         route: Binding<FeatureAction?>
    ) {
        self.repository = repository
        self.analyticsManager = analyticsManager
        self.observabilityManager = observabilityManager
        self._route = route
    }

    // MARK: - Private functions
    private func handleSuccessRequest(response: [FeatureResponse]) {
        data = response.enumerated().compactMap { index, item in
            var title = item.title
            var description = item.subtitle
            var hasBorder = index == 0
            var iconName = item.iconName

            return FeatureViewDTO(title: title,
                                  description: description,
                                  hasBorder: hasBorder,
                                  iconName: iconName)
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
        guard
            let item = viewData[safe: index]
        else {
            state = .error
            log(message: "Error to find item at index: \(index)")
            return
        }

        switch item.type {
        case .openScreen1:
            route = .openScreen1
        case .openScreen2:
            route = .openScreen2
        }
    }
}

// MARK: - FeatureViewModelAnalyticsType
extension FeatureViewModel: FeatureViewModelAnalyticsType {
    func trackScreenView() {
        analyticsManager.track(event: "screen_view", parameters: FeatureAnalyticsEvents.screenView.parameters())
    }

    func trackClickItem(title: String) {
        analyticsManager.track(event: "click", parameters: FeatureAnalyticsEvents.tapItem(title: title).parameters())
    }
}

// MARK: - FeatureViewModelObservability
extension FeatureViewModel: FeatureViewModelObservability {
    func log(message: String) {
        observabilityManager.log(message: message)
    }
}