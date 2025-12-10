import ApiClient
import Dependencies
import SharedModels
import SharedViews
import SwiftUI

@Observable
@MainActor
public class PeopleListViewModel {
    @ObservationIgnored
    @Dependency(\.apiClient) private var apiClient

    var isLoading = false
    var people: [Person] = []

    public init() {}

    func task() async {
        await fetchPeople()
    }

    private func fetchPeople() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await apiClient.fetchPeople(1)
            people = response.results
        } catch {
            reportIssue(error, "Failed to fetch people")
        }
    }
}

public struct PeopleListView: View {
    @State var viewModel: PeopleListViewModel

    public init(viewModel: PeopleListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            ForEach(viewModel.people) { person in
                PersonRowView(person: person)
                    .listRowBackground(Color.app.background)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .background(Color.app.background)
        .navigationTitle("People")
        .task {
            await viewModel.task()
        }
    }
}

struct PersonRowView: View {
    let person: Person

    var body: some View {
        HStack(spacing: 16) {
            if let imageUrl = person.imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.headline)
                    .foregroundStyle(Color.app.primaryLabel)
                    .lineLimit(1)

                Text(person.birthYear)
                    .font(.subheadline)
                    .foregroundStyle(Color.app.secondaryLabel)
            }
        }
    }

    private var placeholderImage: some View {
        Circle()
            .fill(Color.app.cardBackground)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.app.tertiaryLabel)
            }
    }
}

#Preview {
    let _ = prepareDependencies {
        $0.apiClient = .noop
        $0.apiClient.fetchPeople = { _ in
            .init(results: Person.mocks)
        }
    }

    WithStyling {
        NavigationStack {
            PeopleListView(viewModel: PeopleListViewModel())
        }
    }
}
