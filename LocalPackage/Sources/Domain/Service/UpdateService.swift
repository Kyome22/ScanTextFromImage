import Combine
import DataLayer

public actor UpdateService {
    private let spuUpdaterClient: SPUUpdaterClient

    public init(_ spuUpdaterClient: SPUUpdaterClient) {
        self.spuUpdaterClient = spuUpdaterClient
    }

    public func canChecksForUpdatesStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let cancellable = spuUpdaterClient
                .canCheckForUpdatesPublisher()
                .sink { value in
                    continuation.yield(value)
                }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func checkForUpdates() {
        spuUpdaterClient.checkForUpdates()
    }
}

extension AnyCancellable: @retroactive @unchecked Sendable {}
