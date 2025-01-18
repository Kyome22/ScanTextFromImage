import ScreenCaptureKit

public struct ScreenCaptureClient: DependencyClient {
    public var currentShareableContent: @Sendable () async throws -> SCShareableContent
    public var screenWindowsOnlyBelow: @Sendable (SCWindow) async throws -> SCShareableContent
    public var captureImage: @Sendable (SCContentFilter, SCStreamConfiguration) async throws -> CGImage

    public static let liveValue = Self(
        currentShareableContent: {
            try await SCShareableContent.current
        },
        screenWindowsOnlyBelow: {
            try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnlyBelow: $0)
        },
        captureImage: {
            try await SCScreenshotManager.captureImage(contentFilter: $0, configuration: $1)
        }
    )

    public static let testValue = Self(
        currentShareableContent: { throw SCStreamError(.noDisplayList) },
        screenWindowsOnlyBelow: { _ in throw SCStreamError(.noDisplayList) },
        captureImage: { _, _ in throw SCStreamError(.noCaptureSource) }
    )
}
