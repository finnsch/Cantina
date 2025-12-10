import AVFoundation
import Dependencies

extension MusicPlayerClient: DependencyKey {
    public static var liveValue: Self {
        let player = MusicPlayer()
        return Self(
            load: { try await player.load() },
            play: { try await player.play() },
            stop: { try await player.stop() },
        )
    }

    private actor MusicPlayer {
        var player: AVAudioPlayer?

        func load() throws {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: [])

            guard let url = Bundle.module.url(forResource: "cantina", withExtension: "mp3") else {
                return
            }

            player = try AVAudioPlayer(contentsOf: url)
        }

        func play(loop: Bool = true) throws {
            guard let player else {
                return
            }

            player.currentTime = 0
            player.numberOfLoops = loop ? -1 : 0
            player.play()
        }

        func stop() throws {
            player?.stop()
        }
    }
}
