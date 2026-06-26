import Foundation

// Informações dos eventos de analytics
enum FeatureAnalyticsEvents: Equatable {
    case screenView
    case tapItem(title: String)
}

extension FeatureAnalyticsEvents {
    func parameters() -> [String: Any]? {
        switch self {
        case .screenView:
            return [
                "name": "feature_example_screen"
            ]
        case let .tapItem(title):
            return [
                "category": "action",
                "label": "button_\(title)"
            ]
        }
    }
}
