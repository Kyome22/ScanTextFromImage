import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public let appDependencies = AppDependenciesKey.defaultValue
    public let appServices = AppServicesKey.defaultValue

    public func applicationDidFinishLaunching(_ notification: Notification) {
        Task {
            await appServices.logService.bootstrap()
            appServices.logService.notice(.launchApp)
            await appServices.scanTextService.checkPermission()
        }
    }
}
