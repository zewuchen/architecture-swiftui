import Foundation

protocol AnalyticsManagerType {
    func track(event: String, parameters: [String: Any])
}

struct AnalyticsMock: AnalyticsManagerType {
    func track(event: String, parameters: [String: Any]) {
        print("Track event: \(event), parameters: \(parameters)")
    }
}
