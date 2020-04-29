//
//  ScreenshotPanel.swift
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
import SpiceKey

class ScreenshotPanel: NSPanel {

    private var screenshotView: ScreenshotView!
    private var monitors = [Any?]()
    private var point: NSPoint {
        return NSEvent.mouseLocation - self.frame.origin
    }
    
    init(_ frame: NSRect) {
        super.init(contentRect: frame,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: true)
        self.level = NSWindow.Level.popUpMenu
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor(white: 0.0, alpha: 0.02)
        setMonitors()
        setScreenshotView()
    }

    override func close() {
        for monitor in monitors {
            NSEvent.removeMonitor(monitor!)
        }
        monitors.removeAll()
        super.close()
    }
    
    private func setMonitors() {
        
        // mouse down
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown, handler: { (event) -> NSEvent? in
            self.screenshotView.down(self.point)
            return event
        }))
        
        // mouse drag
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged, handler: { (event) -> NSEvent? in
            self.screenshotView.dragged(self.point)
            return event
        }))
        monitors.append(NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged, handler: { (event) in
            self.screenshotView.dragged(self.point)
        }))
        
        // mouse up
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp, handler: { (event) -> NSEvent? in
            self.screenshotView.up(self.point)
            return event
        }))
        
        // keyDown
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in
            if let key = Key(keyCode: event.keyCode), key == .escape {
                AppDelegate.shared.closePanels()
                return nil
            }
            return event
        }))
    }
    
    private func setScreenshotView() {
        let rect = CGRect(origin: .zero, size: self.frame.size)
        screenshotView = ScreenshotView(rect)
        // screenshotView.addCursorRect(rect, cursor: .crosshair)
        screenshotView.endHandler = { (screenshot) in
            AppDelegate.shared.ocr(screenshot)
        }
        self.contentView?.addSubview(screenshotView)
        screenshotView.translatesAutoresizingMaskIntoConstraints = false
        screenshotView.leftAnchor.constraint(equalTo: self.contentView!.leftAnchor).isActive = true
        screenshotView.topAnchor.constraint(equalTo: self.contentView!.topAnchor).isActive = true
        screenshotView.rightAnchor.constraint(equalTo: self.contentView!.rightAnchor).isActive = true
        screenshotView.bottomAnchor.constraint(equalTo: self.contentView!.bottomAnchor).isActive = true
    }
    
    
}
