// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

extension UIView {
    func addDropShadow(opacity: Float = 0.2, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
