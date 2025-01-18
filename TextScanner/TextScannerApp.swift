//
//  TextScannerApp.swift
//  TextScanner
//
//  Created by Takuto Nakamura on 2025/01/13.
//

import Domain
import Presentation
import SwiftUI
import WindowSceneKit
import Vision

@main
struct TextScannerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @WindowState(.screenshot) private var isPresented = false

    var body: some Scene {
        MenuBarScene()
            .environment(\.appDependencies, appDelegate.appDependencies)
            .environment(\.appServices, appDelegate.appServices)
        ScreenshotScene(isPresented: $isPresented)
            .environment(\.appDependencies, appDelegate.appDependencies)
            .environment(\.appServices, appDelegate.appServices)
    }
}
