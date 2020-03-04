// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import CoreGraphics
import UIKit
import QuartzCore


class VerticalGradient: UIView {
    var colors: [UIColor] = [.clear, .white, .black] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var locations: [CGFloat] = [0.0, 0.5, 1.0] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard colors.count == locations.count else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: getCGColors(), locations: locations) else { return }
        
        context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 0.0, y: bounds.height), options: CGGradientDrawingOptions(rawValue: 0))
    }
    
    fileprivate func getCGColors() -> CFArray {
        var cgColors:[CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        
        return cgColors as CFArray
    }
}
