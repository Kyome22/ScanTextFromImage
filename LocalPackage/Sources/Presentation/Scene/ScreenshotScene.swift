import SwiftUI
import WindowSceneKit

public struct ScreenshotScene: Scene {
    @Environment(\.appDependencies) private var appDependencies
    @Environment(\.appServices) private var appServices
    @Binding var isPresented: Bool

    public init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

    public var body: some Scene {
        WindowScene(isPresented: $isPresented) { _ in
            ScreenshotWindow { windowID in
                ScreenshotView(
                    nsCursorClient: appDependencies.nsCursorClient,
                    nsPasteboardClient: appDependencies.nsPasteboardClient,
                    nsSoundClient: appDependencies.nsSoundClient,
                    windowSceneMessengerClient: appDependencies.windowSceneMessengerClient,
                    logService: appServices.logService,
                    scanTextService: appServices.scanTextService,
                    windowID: windowID
                )
            }
        }
    }
}

private final class ScreenshotWindow: NSWindow {
    init<Content: View>(@ViewBuilder content: (_ windowID: CGWindowID) -> Content) {
        super.init(
            contentRect: .zero,
            styleMask: [.fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        level = .popUpMenu
        collectionBehavior = [.canJoinAllSpaces]
        isOpaque = false
        hasShadow = false
        backgroundColor = NSColor(white: .zero, alpha: 0.02)
        contentView = NSHostingView(rootView: content(CGWindowID(windowNumber)))
    }

    override func center() {
        guard let frame = NSScreen.main?.frame else { return }
        setFrame(frame, display: false, animate: false)
    }

    override func orderFrontRegardless() {
        super.orderFrontRegardless()
        makeKey()
    }

    override var canBecomeKey: Bool { true }

    override func cancelOperation(_ sender: Any?) {
        close()
    }
}
