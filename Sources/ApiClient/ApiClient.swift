import Dependencies
import Foundation
import SharedModels

public struct ApiClient: Sendable {
    public var fetchPeople: @Sendable (_ page: Int) async throws -> PeopleResponse
}

public extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

public extension ApiClient {
    static let noop = Self(
        fetchPeople: { _ in try await Task.never() },
    )
}

extension ApiClient: TestDependencyKey {
    public static let previewValue = Self.noop

    public static let testValue = Self(
        fetchPeople: unimplemented("ApiClient.fetchPeople"),
    )
}

extension ApiClient: DependencyKey {
    public static var liveValue: ApiClient {
        let baseUrl = URL(string: "https://swapi.dev/api/")!
        let session = URLSession.shared

        return .init(
            fetchPeople: { page in
                let url = baseUrl
                    .appending(component: "people")
                    .appending(queryItems: [.init(name: "page", value: "\(page)")])

                return try await request(url: url, session: session)
            },
        )
    }
}

private func request<A: Decodable>(url: URL, session: URLSession) async throws -> A {
    let request = URLRequest(url: url)

    let (data, _) = try await session.data(for: request)

    return try jsonDecoder.decode(A.self, from: data)
}

let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()
