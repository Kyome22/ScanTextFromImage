import DataLayer
import Domain
import SwiftUI

struct MenuView: View {
    @State private var viewModel: MenuViewModel

    init(
        nsAppClient: NSAppClient,
        windowSceneMessengerClient: WindowSceneMessengerClient,
        logService: LogService
    ) {
        viewModel = .init(nsAppClient, windowSceneMessengerClient, logService)
    }

    var body: some View {
        VStack {
            Button {
                viewModel.scanText()
            } label: {
                Text("scanText", bundle: .module)
            }
            Divider()
            Button {
                viewModel.openAbout()
            } label: {
                Text("aboutApp", bundle: .module)
            }
            Button {
                viewModel.terminateApp()
            } label: {
                Text("terminateApp", bundle: .module)
            }
        }
        .onAppear {
            viewModel.onAppear(screenName: String(describing: Self.self))
        }
    }
}

#Preview {
    MenuView(
        nsAppClient: .testValue,
        windowSceneMessengerClient: .testValue,
        logService: .init(.testValue)
    )
}
