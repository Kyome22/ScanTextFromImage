import Combine
import DataLayer
import ScreenCaptureKit
import Vision

public actor ScanTextService {
    private let screenCaptureClient: ScreenCaptureClient
    private let textRecognitionClient: TextRecognitionClient

    public init(
        _ screenCaptureClient: ScreenCaptureClient,
        _ textRecognitionClient: TextRecognitionClient
    ) {
        self.screenCaptureClient = screenCaptureClient
        self.textRecognitionClient = textRecognitionClient
    }

    func checkPermission() async {
        _ = try? await screenCaptureClient.currentShareableContent()
    }

    func captureImage(_ windowID: CGWindowID, _ clippingRect: CGRect) async -> CGImage? {
        do {
            let currentContent = try await screenCaptureClient.currentShareableContent()
            guard let window = currentContent.windows.first(where: { $0.windowID == windowID }) else {
                return nil
            }
            let targetContent = try await screenCaptureClient.screenWindowsOnlyBelow(window)
            guard let display = targetContent.displays.first(where: { $0.frame.intersects(window.frame) }) else {
                return nil
            }
            let filter = SCContentFilter(display: display, including: targetContent.windows)
            filter.includeMenuBar = true
            let configuration = SCStreamConfiguration()
            configuration.captureResolution = .nominal
            configuration.sourceRect = clippingRect
            let scaleFactor = CGFloat(filter.pointPixelScale)
            configuration.width = Int(scaleFactor * clippingRect.width)
            configuration.height = Int(scaleFactor * clippingRect.height)
            let image = try await screenCaptureClient.captureImage(filter, configuration)
            return image
        } catch {
            return nil
        }
    }

    func textRecognize(_ cgImage: CGImage) async -> String? {
        do {
            var request = RecognizeTextRequest()
            request.recognitionLanguages = [.init(identifier: "ja")]
            let imageRequestHandler = ImageRequestHandler(cgImage, orientation: .up)
            let result = try await textRecognitionClient.perform(imageRequestHandler, request)
            return result.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
        } catch {
            return nil
        }
    }
}

extension SCShareableContent: @retroactive @unchecked Sendable {}
