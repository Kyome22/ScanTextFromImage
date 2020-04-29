//
//  ScreenshotPanel.swift
//  ScanTextFromImage
//
//  Created by Takuto Nakamura on 2020/04/27.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
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
//        screenshotView.addCursorRect(rect, cursor: .crosshair)
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
