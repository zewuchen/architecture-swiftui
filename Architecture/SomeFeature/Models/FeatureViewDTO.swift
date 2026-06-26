import Foundation

// Dados de visão
struct FeatureViewDTO: Equatable, Hashable {
    let title: String
    let description: String
    let hasBorder: Bool
    let iconName: String
    let action: FeatureAction
}
