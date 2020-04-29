//
//  AppDelegate.swift
//  ScanTextFromImage
//
//  Created by Takuto Nakamura on 2020/04/27.
//
//  MIT License
//
//  Copyright (c) 2020 Takuto Nakamura
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
