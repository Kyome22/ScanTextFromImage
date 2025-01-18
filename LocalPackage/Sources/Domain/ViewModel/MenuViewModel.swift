import DataLayer
import Foundation
import Observation

@MainActor @Observable public final class MenuViewModel {
    private let nsAppClient: NSAppClient
    private let windowSceneMessengerClient: WindowSceneMessengerClient
    private let logService: LogService

    public init(
        _ nsAppClient: NSAppClient,
        _ windowSceneMessengerClient: WindowSceneMessengerClient,
        _ logService: LogService
    ) {
        self.nsAppClient = nsAppClient
        self.windowSceneMessengerClient = windowSceneMessengerClient
        self.logService = logService
    }

    public func onAppear(screenName: String) {
        logService.notice(.screenView(name: screenName))
    }

    public func scanText() {
        nsAppClient.activate(true)
        windowSceneMessengerClient.request(.open, .screenshot, [:])
    }

    public func activateApp() {
        nsAppClient.activate(true)
    }

    public func openAbout() {
        nsAppClient.activate(true)
        nsAppClient.orderFrontStandardAboutPanel(nil)
    }

    public func terminateApp() {
        nsAppClient.terminate(nil)
    }
}
