import Combine
@preconcurrency import Sparkle

public struct SPUUpdaterClient: DependencyClient {
    var automaticallyChecksForUpdates: @Sendable () -> Bool
    var setAutomaticallyChecksForUpdates: @Sendable (Bool) -> Void
    public var canCheckForUpdatesPublisher: @Sendable () -> AnyPublisher<Bool, Never>
    public var checkForUpdates: @Sendable () -> Void

    public static let liveValue: Self = {
        let updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        return Self(
            automaticallyChecksForUpdates: {
                updaterController.updater.automaticallyChecksForUpdates
            },
            setAutomaticallyChecksForUpdates: {
                updaterController.updater.automaticallyChecksForUpdates = $0
            },
            canCheckForUpdatesPublisher: {
                updaterController.updater.publisher(for: \.canCheckForUpdates).eraseToAnyPublisher()
            },
            checkForUpdates: {
                updaterController.updater.checkForUpdates()
            }
        )
    }()

    public static let testValue = Self(
        automaticallyChecksForUpdates: { false },
        setAutomaticallyChecksForUpdates: { _ in },
        canCheckForUpdatesPublisher: { Just(false).eraseToAnyPublisher() },
        checkForUpdates: {}
    )
}
