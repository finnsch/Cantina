import SwiftUI

public struct AppColor {
    // swiftformat:disable numberFormatting

    // MARK: - Brand Colors

    public let brand = Color(hex: 0xFFE300_FF)
    public let accent = Color(hex: 0xC41E3A_FF)

    // MARK: - Background Colors

    public let background = Color(hex: 0x17191A_FF)
    public let surfaceElevated = Color(hex: 0x1E2022_FF)
    public let cardBackground = Color(hex: 0x252729_FF)

    // MARK: - Text Colors

    public let primaryLabel = Color(hex: 0xFFFFFF_FF)
    public let secondaryLabel = Color(hex: 0xA8AAAC_FF)
    public let tertiaryLabel = Color(hex: 0x6B6E70_FF)
    public let separator = Color(hex: 0x2D3033_FF)

    // swiftformat:enable numberFormatting
}

public extension Color {
    static var app: AppColor {
        .init()
    }
}
