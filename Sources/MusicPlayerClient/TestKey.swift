import Dependencies

public extension DependencyValues {
    var musicPlayer: MusicPlayerClient {
        get { self[MusicPlayerClient.self] }
        set { self[MusicPlayerClient.self] = newValue }
    }
}

extension MusicPlayerClient: TestDependencyKey {
    public static let previewValue = Self.noop
    public static let testValue = Self()
}

public extension MusicPlayerClient {
    static let noop = Self(
        load: {},
        play: {},
        stop: {},
    )
}
