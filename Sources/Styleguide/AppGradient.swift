import SwiftUI

public enum AppGradient {
    public static var `default`: LinearGradient {
        LinearGradient(
            colors: [.app.accent, .app.background],
            startPoint: .top,
            endPoint: .bottom,
        )
    }
}
