import DataLayer
import SwiftUI

public final class AppDependencies: Sendable {
    public let loggingSystemClient: LoggingSystemClient
    public let nsAppClient: NSAppClient
    public let nsCursorClient: NSCursorClient
    public let nsPasteboardClient: NSPasteboardClient
    public let nsSoundClient: NSSoundClient
    public let screenCaptureClient: ScreenCaptureClient
    public let spuUpdaterClient: SPUUpdaterClient
    public let textRecognitionClient: TextRecognitionClient
    public let windowSceneMessengerClient: WindowSceneMessengerClient

    public nonisolated init(
        loggingSystemClient: LoggingSystemClient = .liveValue,
        nsAppClient: NSAppClient = .liveValue,
        nsCursorClient: NSCursorClient = .liveValue,
        nsPasteboardClient: NSPasteboardClient = .liveValue,
        nsSoundClient: NSSoundClient = .liveValue,
        screenCaptureClient: ScreenCaptureClient = .liveValue,
        spuUpdaterClient: SPUUpdaterClient = .liveValue,
        textRecognitionClient: TextRecognitionClient = .liveValue,
        windowSceneMessengerClient: WindowSceneMessengerClient = .liveValue
    ) {
        self.loggingSystemClient = loggingSystemClient
        self.nsAppClient = nsAppClient
        self.nsCursorClient = nsCursorClient
        self.nsPasteboardClient = nsPasteboardClient
        self.nsSoundClient = nsSoundClient
        self.screenCaptureClient = screenCaptureClient
        self.spuUpdaterClient = spuUpdaterClient
        self.textRecognitionClient = textRecognitionClient
        self.windowSceneMessengerClient = windowSceneMessengerClient
    }
}

struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue = AppDependencies()
}

public extension EnvironmentValues {
    var appDependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
