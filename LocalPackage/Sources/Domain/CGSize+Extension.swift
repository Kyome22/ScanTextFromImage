import CoreGraphics

extension CGSize {
    init(_ side: CGFloat) {
        self.init(width: side, height: side)
    }
}

func + (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width + r.width, height: l.height + r.height)
}

func * (l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}
