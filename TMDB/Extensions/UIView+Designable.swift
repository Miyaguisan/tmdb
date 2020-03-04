// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


extension UIView {
    func nibName() -> String {
        let dynamicType = type(of: self).description()
        return dynamicType.components(separatedBy: ".").last!
    }
    
    func loadFile(forcedNibName: String? = nil) -> UIView {
        let dynamicType = type(of: self)
        let bundle = Bundle(for: dynamicType)
        let name = forcedNibName ?? nibName()
        let nib = UINib(nibName: name, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
        
        return view
    }
    
    func loadXIB(forcedNibName: String? = nil) {
        if subviews.count == 0 {
            let xibView = loadFile(forcedNibName: forcedNibName)
            xibView.frame = bounds
            xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(xibView)
        }
    }
}
