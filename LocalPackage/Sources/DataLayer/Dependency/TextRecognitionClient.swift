import Vision

public struct TextRecognitionClient: DependencyClient {
    public var perform: @Sendable (ImageRequestHandler, RecognizeTextRequest) async throws -> RecognizeTextRequest.Result

    public static let liveValue = Self(
        perform: { try await $0.perform($1) }
    )

    public static let testValue = Self(
        perform: { _, _ in
            throw VisionError.operationFailed("Failed to recognize text.")
        }
    )
}
