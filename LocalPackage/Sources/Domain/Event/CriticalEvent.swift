import Logging

public enum CriticalEvent {
    case failedExecuteScript(any Error)

    public var message: Logger.Message {
        switch self {
        case .failedExecuteScript:
            "Failed to execute script."
        }
    }

    public var metadata: Logger.Metadata? {
        switch self {
        case let .failedExecuteScript(error):
            ["cause": "\(error.localizedDescription)"]
        }
    }
}
