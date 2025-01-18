import DataLayer
import Domain
import SwiftUI

struct ScreenshotView: View {
    @State private var viewModel: ScreenshotViewModel

    init(
        nsCursorClient: NSCursorClient,
        nsPasteboardClient: NSPasteboardClient,
        nsSoundClient: NSSoundClient,
        windowSceneMessengerClient: WindowSceneMessengerClient,
        logService: LogService,
        scanTextService: ScanTextService,
        windowID: CGWindowID
    ) {
        viewModel = .init(nsCursorClient,
                          nsPasteboardClient,
                          nsSoundClient,
                          windowSceneMessengerClient,
                          logService,
                          scanTextService,
                          windowID)
    }

    var body: some View {
        Canvas { context, size in
            var path = Path(CGRect(origin: .zero, size: size))
            path.addRect(viewModel.clippingRect)
            context.fill(path, with: .color(.black.opacity(0.4)), style: .init(eoFill: true))
            if !viewModel.clippingRect.size.equalTo(.zero) {
                context.stroke(
                    Path(viewModel.clippingRect),
                    with: .color(.white),
                    style: .init(lineWidth: 1, dash: [5, 5])
                )
                context.stroke(
                    Path(viewModel.clippingRect),
                    with: .color(.black),
                    style: .init(lineWidth: 1, dash: [5, 5], dashPhase: 5)
                )
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    viewModel.dragMoved(startLocation: value.startLocation, location: value.location)
                }
                .onEnded { value in
                    Task {
                        await viewModel.dragEnded(startLocation: value.startLocation, location: value.location)
                    }
                }
        )
        .onAppear {
            viewModel.onAppear(screenName: String(describing: Self.self))
        }
        .overlay(alignment: .topTrailing) {
            Button {
                viewModel.close()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.borderless)
            .padding()
        }
    }
}

#Preview {
    ScreenshotView(
        nsCursorClient: .testValue,
        nsPasteboardClient: .testValue,
        nsSoundClient: .testValue,
        windowSceneMessengerClient: .testValue,
        logService: .init(.testValue),
        scanTextService: .init(.testValue, .testValue),
        windowID: .zero
    )
}
