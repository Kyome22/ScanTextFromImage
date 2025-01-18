import DataLayer
import SwiftUI

public final class AppServices: Sendable {
    public let logService: LogService
    public let scanTextService: ScanTextService

    public nonisolated init(appDependencies: AppDependencies) {
        logService = .init(appDependencies.loggingSystemClient)
        scanTextService = .init(appDependencies.screenCaptureClient,
                                appDependencies.textRecognitionClient)
    }
}

struct AppServicesKey: EnvironmentKey {
    static let defaultValue = AppServices(appDependencies: AppDependenciesKey.defaultValue)
}

public extension EnvironmentValues {
    var appServices: AppServices {
        get { self[AppServicesKey.self] }
        set { self[AppServicesKey.self] = newValue }
    }
}
