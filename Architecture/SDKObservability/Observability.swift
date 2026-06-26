import Foundation

protocol ObservabilityManagerType {
    func log(message: String)
}

struct ObservabilityMock: ObservabilityManagerType {
    func log(message: String) {
        print("Log: \(message)")
    }
}
