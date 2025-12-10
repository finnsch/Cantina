import AppFeature
import SharedViews
import SwiftUI

@main
struct CantinaApp: App {
    var body: some Scene {
        WindowGroup {
            WithStyling {
                AppView(viewModel: AppViewModel())
            }
        }
    }
}
