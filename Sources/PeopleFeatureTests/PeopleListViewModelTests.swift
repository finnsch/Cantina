import Dependencies
import Foundation
import SharedModels
import Testing

@testable import PeopleFeature

@MainActor
struct PeopleFeatureTests {
    @Test func `task loads people`() async throws {
        let viewModel = withDependencies {
            $0.apiClient.fetchPeople = { _ in
                .init(
                    next: URL(string: "/")!,
                    results: Person.mocks,
                )
            }
        } operation: {
            PeopleListViewModel()
        }

        await viewModel.task()

        #expect(viewModel.people == Person.mocks)
    }

    @Test func `task loads people fails`() async throws {
        struct ApiError: Error {}
        let viewModel = withDependencies {
            $0.apiClient.fetchPeople = { _ in
                throw ApiError()
            }
        } operation: {
            PeopleListViewModel()
        }

        await withKnownIssue {
            await viewModel.task()
        } when: {
            true
        } matching: { issue in
            issue.error is ApiError
        }
    }

    @Test func `task loads people and plays music`() async throws {
        await withMainSerialExecutor {
            let playedMusic = LockIsolated(false)
            let viewModel = withDependencies {
                $0.apiClient.fetchPeople = { _ in
                    .init(results: Person.mocks)
                }
                $0.musicPlayer.play = {
                    playedMusic.setValue(true)
                }
            } operation: {
                PeopleListViewModel()
            }

            await viewModel.task()
            await Task.yield()

            #expect(viewModel.people == Person.mocks)
            #expect(playedMusic.value == true)
        }
    }

    @Test func `filter people`() async throws {
        let viewModel = withDependencies {
            $0.apiClient.fetchPeople = { _ in
                .init(
                    next: URL(string: "/")!,
                    results: Person.mocks,
                )
            }
        } operation: {
            PeopleListViewModel()
        }

        await viewModel.task()

        viewModel.searchText = "sky"

        #expect(viewModel.people == Person.mocks)

        viewModel.searchText = "skyy"

        #expect(viewModel.people == [])
    }

    @Test func `load next page at end of list`() async throws {
        let requestedPage = LockIsolated(Int?.none)
        let viewModel = withDependencies {
            $0.apiClient.fetchPeople = { page in
                requestedPage.setValue(page)

                return .init(
                    next: URL(string: "/")!,
                    results: Person.mocks,
                )
            }
        } operation: {
            PeopleListViewModel()
        }

        await viewModel.endOfListReached()

        #expect(requestedPage.value == 2)
    }

    @Test func `stop music`() async throws {
        let stoppedMusic = LockIsolated(false)
        let viewModel = withDependencies {
            $0.musicPlayer.stop = {
                stoppedMusic.setValue(true)
            }
        } operation: {
            PeopleListViewModel()
        }

        await viewModel.waveformButtonTapped()

        #expect(stoppedMusic.value == true)
    }
}
