import WindowSceneKit

public struct WindowSceneMessengerClient: DependencyClient {
    public var request: @Sendable (WindowAction, String, [String : any Sendable]) -> Void

    public static let liveValue = Self(
        request: { WindowSceneMessenger.request(windowAction: $0, windowKey: $1, supplements: $2) }
    )

    public static let testValue = Self(
        request: { _, _, _ in }
    )
}
