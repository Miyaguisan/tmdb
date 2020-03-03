// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class CircularLoadingIndicator: UIView {
    weak var circleLayer: CAShapeLayer? = nil
    let indeterminateDuration: Double = 2.0
    var desiredRadius: CGFloat = 0.25 {
        didSet {
            update()
        }
    }
    
    func destroyPath() {
        circleLayer?.removeAllAnimations()
        circleLayer?.removeFromSuperlayer()
        circleLayer = nil
    }
    
    deinit {
        destroyPath()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    func update(color: UIColor = .link) {
        isHidden = true
        isOpaque = true
        destroyPath()
        
        let offset: CGFloat = 0.0
        let arcCenter = CGPoint(x: (bounds.width / 2.0), y: (bounds.height / 2.0) - offset)
        let radius = (bounds.width * desiredRadius)
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat(.pi * 2.0)
        
        let casl = CAShapeLayer()
        casl.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        casl.fillColor = UIColor.clear.cgColor
        casl.strokeColor = color.cgColor
        casl.lineWidth = 2.0
        casl.strokeEnd = 0.0
        layer.addSublayer(casl)
        
        circleLayer = casl
        setNeedsDisplay()
    }
    
    func setProgress(_ progress: CGFloat) {
        circleLayer?.strokeEnd = progress
    }
    
    func animate() {
        circleLayer?.add(generateAnimation(), forKey: "strokeLineAnimation")
        layer.add(generateRotationAnimation(), forKey: "rotationAnimation")
        isHidden = false
    }
    
    func stop() {
        isHidden = true
        circleLayer?.removeAllAnimations()
        layer.removeAllAnimations()
    }
}

extension CircularLoadingIndicator {
    fileprivate func generateAnimation() -> CAAnimationGroup {
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.beginTime = indeterminateDuration / 3
        headAnimation.fromValue = 0
        headAnimation.toValue = 1
        headAnimation.duration = indeterminateDuration / 1.5
        headAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.duration = indeterminateDuration / 1.5
        tailAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.beginTime = indeterminateDuration / 4
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = indeterminateDuration / 2.0
        fadeOut.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = indeterminateDuration
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.animations = [headAnimation, tailAnimation, fadeOut]
        return groupAnimation
    }
    
    fileprivate func generateRotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (.pi * 3.5)
        animation.duration = indeterminateDuration
        animation.repeatCount = Float.infinity
        return animation
    }
}
