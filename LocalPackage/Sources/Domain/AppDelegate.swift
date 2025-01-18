import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public let appDependencies = AppDependencies()
    public let appServices: AppServices

    public override init() {
        appServices = .init(appDependencies: appDependencies)
        super.init()
    }

    public func applicationDidFinishLaunching(_ notification: Notification) {
        Task {
            await appServices.logService.bootstrap()
            appServices.logService.notice(.launchApp)
            await appServices.scanTextService.checkPermission()
        }
    }
}
