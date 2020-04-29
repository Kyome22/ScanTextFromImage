//
//  Extensions.swift
//  ScanTextFromImage
//
//  Created by Takuto Nakamura on 2020/04/27.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import AppKit
import CoreGraphics

func logput(_ item: Any, file: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
    Swift.print("Log: \(file):Line\(line):\(function)", item)
    #endif
}

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

func - (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func * (l: CGFloat, r: CGPoint) -> CGPoint {
    return CGPoint(x: l * r.x, y: l * r.y)
}

func / (l: CGPoint, r: CGFloat) -> CGPoint {
    if r == 0.0 { return CGPoint.zero }
    return CGPoint(x: l.x / r, y: l.y / r)
}

func * (l: CGFloat, r: CGRect) -> CGRect {
    return CGRect(x: l * r.origin.x, y: l * r.origin.y, width: l * r.width, height: l * r.height)
}

func + (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width + r.width, height: l.height + r.height)
}

func * (l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}

extension CGPoint {
    init(_ scalar: CGFloat) {
        self.init(x: scalar, y: scalar)
    }
    
    func length(from: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - from.x, 2.0) + pow(self.y - from.y, 2.0))
    }
    
    func radian(from: CGPoint) -> CGFloat {
        return atan2(self.y - from.y, self.x - from.x)
    }
}

extension CGSize {
    // widthとheightの大きさが同じ時の初期化
    init(_ side: CGFloat) {
        self.init(width: side, height: side)
    }
}

extension NSScreen {
    static var totalRect: CGRect {
        return screens.reduce(CGRect.zero) { (result, screen) -> CGRect in
            return result.union(screen.frame)
        }
    }
}

extension CGImage {
    static func background(_ frame: CGRect, _ windowID: CGWindowID) -> CGImage? {
        let windowOptions: CGWindowListOption = [.optionOnScreenOnly, .optionOnScreenBelowWindow]
        let imageOptions: CGWindowImageOption = [.nominalResolution, .boundsIgnoreFraming]
        guard let image = CGWindowListCreateImage(CGRect.null, windowOptions, windowID, imageOptions) else {
            return nil
        }
        let totalRect = NSScreen.totalRect
        let origin = CGPoint(x: frame.minX - totalRect.minX, y: totalRect.maxY - frame.maxY)
        return image.cropping(to: NSRect(origin: origin, size: frame.size))
    }
}
