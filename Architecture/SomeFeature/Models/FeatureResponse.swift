import Foundation

// Resposta do backend
struct FeatureResponse: Decodable {
    let title: String
    let subtitle: String
    let iconName: String

    init(title: String,
         subtitle: String,
         iconName: String) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
    }
}
