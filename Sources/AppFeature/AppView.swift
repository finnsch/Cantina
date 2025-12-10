import HomeFeature
import Observation
import PeopleFeature
import SharedViews
import SwiftUI

public enum Tab: Hashable {
    case people
}

@Observable
public class AppViewModel: ObservableObject {
    var selectedTab: Tab

    public init(selectedTab: Tab = .people) {
        self.selectedTab = selectedTab
    }
}

public struct AppView: View {
    @State var viewModel: AppViewModel

    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            Group {
                NavigationStack {
                    PeopleListView(viewModel: PeopleListViewModel())
                }
                .tabItem {
                    Label("People", systemImage: "person.3.fill")
                }
                .tag(Tab.people)
            }
        }
        .tint(.app.brand)
    }
}

#Preview {
    WithStyling {
        AppView(viewModel: AppViewModel())
    }
}
