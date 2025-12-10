import Styleguide
import SwiftUI

public struct WithStyling<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(.app.brand),
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(.app.brand),
        ]

        self.content = content()
    }

    public var body: some View {
        content
            .preferredColorScheme(.dark)
    }
}
