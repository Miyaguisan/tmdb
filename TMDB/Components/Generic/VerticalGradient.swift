// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import CoreGraphics
import UIKit
import QuartzCore


class VerticalGradient: UIView {
    var colors:[UIColor] = [.white, .lightGray, .white] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var locations:[CGFloat] = [0.0, 0.5, 1.0] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard colors.count == locations.count else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations) else { return }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }
}
