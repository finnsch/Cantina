import SwiftUI

extension Color {
    init(hex: Int) {
        self.init(
            red: Double((hex >> 24) & 0xFF) / 255.0,
            green: Double((hex >> 16) & 0xFF) / 255.0,
            blue: Double((hex >> 8) & 0xFF) / 255.0,
            opacity: Double(hex & 0xFF) / 0xFF,
        )
    }
}
