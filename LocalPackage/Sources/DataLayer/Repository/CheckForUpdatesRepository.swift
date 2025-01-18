public struct CheckForUpdatesRepository: Sendable {
    private var spuUpdaterClient: SPUUpdaterClient

    public var isEnabled: Bool {
        spuUpdaterClient.automaticallyChecksForUpdates()
    }

    public init(_ spuUpdaterClient: SPUUpdaterClient) {
        self.spuUpdaterClient = spuUpdaterClient
    }

    public func switchStatus(_ isEnabled: Bool) {
        spuUpdaterClient.setAutomaticallyChecksForUpdates(isEnabled)
    }
}
