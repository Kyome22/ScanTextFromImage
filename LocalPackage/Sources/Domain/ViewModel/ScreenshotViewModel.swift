import AppKit
import CoreGraphics
import DataLayer
import Foundation
import Observation

@MainActor @Observable public final class ScreenshotViewModel {
    private let nsCursorClient: NSCursorClient
    private let nsPasteboardClient: NSPasteboardClient
    private let nsSoundClient: NSSoundClient
    private let windowSceneMessengerClient: WindowSceneMessengerClient
    private let logService: LogService
    private let scanTextService: ScanTextService
    private let windowID: CGWindowID

    public var clippingRect = CGRect.zero

    public init(
        _ nsCursorClient: NSCursorClient,
        _ nsPasteboardClient: NSPasteboardClient,
        _ nsSoundClient: NSSoundClient,
        _ windowSceneMessengerClient: WindowSceneMessengerClient,
        _ logService: LogService,
        _ scanTextService: ScanTextService,
        _ windowID: CGWindowID
    ) {
        self.nsCursorClient = nsCursorClient
        self.nsPasteboardClient = nsPasteboardClient
        self.nsSoundClient = nsSoundClient
        self.windowSceneMessengerClient = windowSceneMessengerClient
        self.logService = logService
        self.scanTextService = scanTextService
        self.windowID = windowID
    }

    public func onAppear(screenName: String) {
        logService.notice(.screenView(name: screenName))
    }

    public func dragMoved(startLocation: CGPoint, location: CGPoint) {
        if !nsCursorClient.equal(.current, .crosshair) {
            nsCursorClient.push(.crosshair)
        }
        clippingRect = calcurateRect(startLocation, location)
    }

    public func dragEnded(startLocation: CGPoint, location: CGPoint) async {
        defer {
            windowSceneMessengerClient.request(.close, .screenshot, [:])
        }
        nsCursorClient.pop()
        let rect = calcurateRect(startLocation, location)
        guard let cgImage = await scanTextService.captureImage(windowID, rect),
              let text = await scanTextService.textRecognize(cgImage) else {
            return
        }
        _ = nsPasteboardClient.clearContents()
        _ = nsPasteboardClient.declareTypes([.string], nil)
        if nsPasteboardClient.setString(text, .string),
           let sound = NSSound(named: "Tink") {
            nsSoundClient.play(sound)
        }
    }

    func calcurateRect(_ pointA: CGPoint, _ pointB: CGPoint) -> CGRect {
        let x = min(pointA.x, pointB.x)
        let y = min(pointA.y, pointB.y)
        let width = abs(pointA.x - pointB.x)
        let height = abs(pointA.y - pointB.y)
        return CGRect(x: x, y: y, width: width, height: height)
    }

    public func close() {
        windowSceneMessengerClient.request(.close, .screenshot, [:])
    }
}
