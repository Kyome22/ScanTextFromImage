import CoreGraphics

extension CGPoint {
    init(_ scalar: CGFloat) {
        self.init(x: scalar, y: scalar)
    }

    func length(from: CGPoint) -> CGFloat {
        sqrt(pow(x - from.x, 2.0) + pow(y - from.y, 2.0))
    }

    func radian(from: CGPoint) -> CGFloat {
        atan2(y - from.y, x - from.x)
    }
}

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    CGPoint(x: l.x + r.x, y: l.y + r.y)
}

func - (l: CGPoint, r: CGPoint) -> CGPoint {
    CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func * (l: CGFloat, r: CGPoint) -> CGPoint {
    CGPoint(x: l * r.x, y: l * r.y)
}

func / (l: CGPoint, r: CGFloat) -> CGPoint {
    if r == .zero {
        CGPoint.zero
    } else {
        CGPoint(x: l.x / r, y: l.y / r)
    }
}
