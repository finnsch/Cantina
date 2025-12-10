import DependenciesMacros

@DependencyClient
public struct MusicPlayerClient: Sendable {
    public var load: @Sendable () async throws -> Void
    public var play: @Sendable () async throws -> Void
    public var stop: @Sendable () async throws -> Void
}
