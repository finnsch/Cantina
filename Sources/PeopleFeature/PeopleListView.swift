import Dependencies
import SharedModels
import SharedViews
import SwiftUI

public struct PeopleListView: View {
    @State var viewModel: PeopleListViewModel

    public init(viewModel: PeopleListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            if viewModel.showError {
                errorContent
            } else if viewModel.hasNoSearchResults {
                ContentUnavailableView.search(text: viewModel.searchText)
            } else {
                listContent
            }
        }
        .background(Color.app.background)
        .toolbar {
            ToolbarItem {
                if viewModel.isPlayingMusic {
                    Button {
                        Task {
                            await viewModel.waveformButtonTapped()
                        }
                    } label: {
                        Image(systemName: "waveform")
                            .symbolEffect(
                                .breathe,
                                options: .repeating,
                                isActive: viewModel.isPlayingMusic,
                            )
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("People")
        .sheet(item: $viewModel.presentedPerson) { person in
            PersonDetailView(person: person)
        }
        .task {
            await viewModel.task()
        }
    }

    private var errorContent: some View {
        ContentUnavailableView {
            Label {
                Text("Failed to load people")
            } icon: {
                Image(systemName: "exclamationmark.triangle")
            }
        } description: {
            Text("Something went wrong. Please try again.")
        } actions: {
            Button("Retry") {
                Task {
                    await viewModel.retryButtonTapped()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var listContent: some View {
        List {
            ForEach(viewModel.people) { person in
                Button {
                    viewModel.rowTapped(person: person)
                } label: {
                    PersonRowView(person: person)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.app.background)
                .listRowSeparator(.hidden)
            }

            if !viewModel.reachedEnd, !viewModel.isSearching {
                ProgressView()
                    .tint(.app.brand)
                    .listRowBackground(Color.app.background)
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .task {
                        await viewModel.endOfListReached()
                    }
            }
        }
        .listStyle(.plain)
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

#if DEBUG
    #Preview("Success") {
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

    #Preview("Network error") {
        let _ = prepareDependencies {
            $0.apiClient = .testValue
        }

        WithStyling {
            NavigationStack {
                PeopleListView(viewModel: PeopleListViewModel())
            }
        }
    }

    #Preview("Empty search results") {
        let _ = prepareDependencies {
            $0.apiClient = .noop
            $0.apiClient.fetchPeople = { _ in
                .init(results: Person.mocks)
            }
        }
        let viewModel = PeopleListViewModel(searchText: "Skyy")

        WithStyling {
            NavigationStack {
                PeopleListView(viewModel: viewModel)
            }
        }
    }
#endif
