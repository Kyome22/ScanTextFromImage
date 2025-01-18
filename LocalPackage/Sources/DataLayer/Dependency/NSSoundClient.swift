import AppKit

public struct NSSoundClient: DependencyClient {
    public var play: @Sendable (NSSound) -> Void

    public static let liveValue = Self(
        play: { $0.play() }
    )

    public static let testValue = Self(
        play: { _ in }
    )
}
