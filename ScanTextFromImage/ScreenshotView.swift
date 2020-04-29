//
//  ScreenshotView.swift
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

class ScreenshotView: NSView {
    
    var startPoint: NSPoint?
    var endPoint: NSPoint?
    var endHandler: ((_ screenshot: CGImage) -> Void)?

    init(_ frame: CGRect) {
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = CGColor.clear
        addCursorRect(self.visibleRect, cursor: .iBeam)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateTrackingAreas() {
        for area in self.trackingAreas {
            self.removeTrackingArea(area)
        }
        if bounds.size.width == 0 || bounds.size.height == 0 { return }
        let options: NSTrackingArea.Options = [.activeAlways, .mouseEnteredAndExited]
        let trackingArea = NSTrackingArea(rect: self.frame, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        NSCursor.crosshair.push()
    }
    
    override func mouseExited(with event: NSEvent) {
        NSCursor.crosshair.pop()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let start = startPoint, let end = endPoint else { return }
        if start == end {
            NSColor.textColor.setFill()
            NSBezierPath(rect: NSRect(origin: start - CGPoint(2), size: CGSize(4))).fill()
            return
        }
        let lb = CGPoint(x: min(start.x, end.x), y: min(start.y, end.y))
        let w = abs(end.x - start.x)
        let h = abs(end.y - start.y)
        let rect = CGRect(origin: lb, size: CGSize(width: w, height: h))
        let path = NSBezierPath(rect: rect)
        NSColor.textBackgroundColor.withAlphaComponent(0.2).setFill()
        path.fill()
        path.lineWidth = 1.0
        NSColor.textColor.setStroke()
        path.stroke()
    }
    
    func down(_ point: NSPoint) {
        if !self.bounds.contains(point) { return }
        startPoint = point
        endPoint = point
        self.needsDisplay = true
    }
    
    func dragged(_ point: NSPoint) {
        if startPoint == nil { return }
        endPoint = point
        self.needsDisplay = true
    }
    
    func up(_ point: NSPoint) {
        if startPoint == nil { return }
        endPoint = point
        getScreenshot()
    }
    
    func getScreenshot() {
        guard let start = startPoint, let end = endPoint, start != end else { return }
        guard
            let window = self.window,
            let cgImage = CGImage.background(window.frame, CGWindowID(window.windowNumber))
            else { return }
        let lt = CGPoint(x: min(start.x, end.x), y: window.frame.height - max(start.y, end.y))
        let w = abs(end.x - start.x)
        let h = abs(end.y - start.y)
        let rect = CGRect(origin: lt, size: CGSize(width: w, height: h))
        guard let croppedImage = cgImage.cropping(to: rect) else { return }
        endHandler?(croppedImage)
        startPoint = nil
        endPoint = nil
    }
    
}
