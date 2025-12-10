import SwiftUI

public struct AppColor {
    // MARK: - Brand Colors

    public let brand = Color(hex: 0xFFE3_00FF)
    public let accent = Color(hex: 0xC41E_3AFF)

    // MARK: - Background Colors

    public let background = Color(hex: 0x1719_1AFF)
    public let surfaceElevated = Color(hex: 0x1E20_22FF)
    public let cardBackground = Color(hex: 0x2527_29FF)

    // MARK: - Text Colors

    public let primaryLabel = Color(hex: 0xFFFF_FFFF)
    public let secondaryLabel = Color(hex: 0xA8AA_ACFF)
    public let tertiaryLabel = Color(hex: 0x6B6E_70FF)
    public let separator = Color(hex: 0x2D30_33FF)
}

public extension Color {
    static var app: AppColor {
        .init()
    }
}
