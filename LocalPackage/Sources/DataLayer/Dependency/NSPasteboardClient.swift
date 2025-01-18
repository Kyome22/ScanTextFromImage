import AppKit

public struct NSPasteboardClient: DependencyClient {
    public var clearContents: @Sendable () -> Int
    public var declareTypes: @Sendable ([NSPasteboard.PasteboardType], Any?) -> Int
    public var setString: @Sendable (String, NSPasteboard.PasteboardType) -> Bool

    public static let liveValue = Self(
        clearContents: { NSPasteboard.general.clearContents() },
        declareTypes: { NSPasteboard.general.declareTypes($0, owner: $1) },
        setString: { NSPasteboard.general.setString($0, forType: $1) }
    )

    public static let testValue = Self(
        clearContents: { .zero },
        declareTypes: { _, _ in .zero },
        setString: { _, _ in false }
    )
}
