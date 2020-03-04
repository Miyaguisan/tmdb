// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

extension UIViewController {
    func addBlurToNavBar() {
        guard let navigationController = navigationController else { return }
        
        let firstSubview = navigationController.navigationBar.subviews.first
        guard firstSubview is UIVisualEffectView == false else { return }
        
        var bounds = navigationController.navigationBar.bounds
        bounds = bounds.offsetBy(dx: 0.0, dy: -20.0)
        bounds.size.height += 20
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationController.navigationBar.addSubview(visualEffectView)
        visualEffectView.layer.zPosition = -1
    }
    
    func removeBlurFromNavBar() {
        guard let navigationController = navigationController else { return }
        guard let blurView = navigationController.navigationBar.subviews.first as? UIVisualEffectView else { return }
        
        blurView.removeFromSuperview()
    }
}
