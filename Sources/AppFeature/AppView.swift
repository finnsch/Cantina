import Observation
import SwiftUI

@Observable
public class AppViewModel: ObservableObject {
    public init() {}
}

public struct AppView: View {
    @State var viewModel: AppViewModel

    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        EmptyView()
    }
}

#Preview {
    AppView(viewModel: AppViewModel())
}
