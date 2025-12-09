import AppFeature
import SwiftUI

@main
struct CantinaApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel())
        }
    }
}
