import ApiClient
import Dependencies
import MusicPlayerClient
import SharedModels
import SwiftUI

@Observable
@MainActor
public class PeopleListViewModel {
    @ObservationIgnored
    @Dependency(\.apiClient) private var apiClient
    @ObservationIgnored
    @Dependency(\.musicPlayer) var musicPlayer

    var isLoading = false
    var people: [Person] = []
    var searchText: String {
        didSet {
            if oldValue != searchText {
                filterPeople()
            }
        }
    }

    var presentedPerson: Person?

    private var allPeople: [Person] = []
    private var currentPage = 1
    private(set) var showError = false
    private(set) var isPlayingMusic = false
    private(set) var reachedEnd = false {
        didSet {
            if reachedEnd, !isPlayingMusic {
                playMusic()
            }
        }
    }

    var isSearching: Bool {
        !searchText.isEmpty
    }

    var hasNoSearchResults: Bool {
        isSearching && people.isEmpty
    }

    public init(searchText: String = "") {
        self.searchText = searchText
    }

    func task() async {
        await fetchPeople()
    }

    private func fetchPeople() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await apiClient.fetchPeople(currentPage)
            showError = false
            reachedEnd = response.next == nil
            allPeople.append(contentsOf: response.results)
            filterPeople()
        } catch {
            showError = true
            reportIssue(error, "Failed to fetch people at page \(currentPage)")
        }
    }

    func endOfListReached() async {
        if !isLoading {
            currentPage += 1
            await fetchPeople()
        }
    }

    private func filterPeople() {
        guard !searchText.isEmpty else {
            people = allPeople
            return
        }

        people = allPeople.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    func waveformButtonTapped() async {
        await withErrorReporting {
            try await musicPlayer.stop()
            isPlayingMusic = false
        }
    }

    private func playMusic() {
        Task {
            await withErrorReporting {
                try await musicPlayer.play()
                isPlayingMusic = true
            }
        }
    }

    func rowTapped(person: Person) {
        presentedPerson = person
    }

    func retryButtonTapped() async {
        showError = false
        currentPage = 1
        allPeople = []
        people = []
        reachedEnd = false
        await fetchPeople()
    }
}
