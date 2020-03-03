// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import CoreGraphics
import UIKit
import QuartzCore


@IBDesignable
class DesignableGradient: UIView {
    @IBInspectable
    var outterColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var innerColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let colors = [outterColor.cgColor, innerColor.cgColor, outterColor.cgColor]
        let locations:[CGFloat] = [0.0, 0.5, 1.0]
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations) else { return }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }
}
