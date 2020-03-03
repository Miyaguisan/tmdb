// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

extension UIView {
    func addDropShadow(opacity: Float = 0.25, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        layer.shadowPath = shadowPath.cgPath
    }
    
    func setVisible(_ visible: Bool, animated: Bool = true, duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, onComplete: (() -> Void)? = nil) {
        if visible == true {
            alpha = 0.0
            isHidden = false
        }
        
        UIView.animate(withDuration: animated ? duration : 0.0,
                       delay: delay,
                       options: [.beginFromCurrentState],
                       animations: {
                        self.alpha = visible ? 1.0 : 0.0
        }) { (finished) in
            if visible == false {
                self.isHidden = true
            }
            
            onComplete?()
        }
    }
}
