import AppKit

public struct NSCursorClient: DependencyClient {
    public var push: @Sendable (NSCursor) -> Void
    public var pop: @Sendable () -> Void
    public var equal: @Sendable (NSCursor, NSCursor) -> Bool

    public static let liveValue = Self(
        push: { $0.push() },
        pop: { NSCursor.pop() },
        equal: { $0 == $1 }
    )

    public static let testValue = Self(
        push: { _ in },
        pop: {},
        equal: { _, _ in false }
    )
}
