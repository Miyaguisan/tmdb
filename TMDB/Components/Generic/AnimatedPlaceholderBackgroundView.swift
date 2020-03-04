// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class AnimatedPlaceholderBackgroundView: UIView {
    var scroll: UIScrollView?
    var gradient: Gradient?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGradient()
    }
    
    private func addGradient() {
        guard gradient == nil, scroll == nil else { return }
        
        isHidden = true
        alpha = 0.0
        isOpaque = true
        backgroundColor = .white
        
        let s = UIScrollView()
        s.isOpaque = true
        s.backgroundColor = .white
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s.frame = bounds
        s.contentSize.width = bounds.width * 3.0
        s.contentOffset.x = bounds.width * 2.0
        
        let g = Gradient()
        g.direction = .horizontal
        g.colors = [.white, UIColor(white: 1.0, alpha: 0.95), .white]
        
        g.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        g.frame = bounds
        s.addSubview(g)
        g.frame.origin.y = bounds.width
        
        insertSubview(s, at: 0)
        gradient = g
        scroll = s
    }
    
    func animate(delay: TimeInterval = 0.0) {
        scroll?.frame = bounds
        scroll?.contentOffset.x = bounds.width * 2.0
        gradient?.frame = bounds
        gradient?.frame.origin.x = bounds.width
        gradient?.setNeedsDisplay()

        setVisible(true, animated: true, onComplete: {
            UIView.animate(withDuration: 1.5,
                           delay: delay,
                           options: [.beginFromCurrentState, .repeat], animations: {
                            self.scroll?.setContentOffset(.zero, animated: false)
            }, completion: nil)
        })
    }
    
    func stop() {
        layer.removeAllAnimations()
        isHidden = true
        alpha = 0.0
    }
}
