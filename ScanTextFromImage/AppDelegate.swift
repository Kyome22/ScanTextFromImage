//
//  AppDelegate.swift
//  ScanTextFromImage
//
//  Created by Takuto Nakamura on 2020/04/27.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Cocoa
import Vision
import SpiceKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var panels = [ScreenshotPanel]()
    private var spiceKey: SpiceKey!
    private var cursor: NSCursor?
    
    class var shared: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = menu
        statusItem.button?.image = NSImage(named: "statusIcon")
        let combination = KeyCombination(Key.c, ModifierFlags(control: false, option: false, shift: true, command: true)!)
        spiceKey = SpiceKey(combination, keyDownHandler: { [weak self] in
            self?.scan(nil)
        })
        spiceKey.register()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        spiceKey.unregister()
    }
    
    func saveScreenshot(_ screenshot: CGImage) {
        guard let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            return
        }
        let url = dir.appendingPathComponent(UUID().uuidString + ".png")
        let bitRep = NSBitmapImageRep(cgImage: screenshot)
        guard let pngRep = bitRep.representation(using: .png, properties: [:]) else { return }
        try? pngRep.write(to: url)
    }
    
    func ocr(_ screenshot: CGImage) {
        // saveScreenshot(screenshot)
        let request = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            let text = results.map { (result) -> String in
                let candidate = result.topCandidates(1).first!
                return candidate.string
            }.joined(separator: "\n")
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
            NSSound(named: "Glass")?.play()
        }
        let requestHandler = VNImageRequestHandler(cgImage: screenshot, orientation: .up, options: [:])
        try? requestHandler.perform([request])
        closePanels()
    }
    
    func closePanels() {
        cursor?.set()
        panels.forEach { (panel) in
            panel.close()
        }
        panels.removeAll()
    }
    
    @IBAction func scan(_ sender: Any?) {
        if !panels.isEmpty { return }
        cursor = NSCursor.current
        NSApp.activate(ignoringOtherApps: true)
        for screen in NSScreen.screens {
            let panel = ScreenshotPanel(screen.frame)
            panels.append(panel)
            panel.orderFrontRegardless()
        }
    }

    @IBAction func openAbout(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
}
