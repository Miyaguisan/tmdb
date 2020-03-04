// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


@IBDesignable
class EntertainmentItem: UIView {
    @IBOutlet private weak var iconLabel: UILabel?
    @IBOutlet private weak var textLabel: UILabel?
    
    @IBInspectable
    var iconColor: UIColor? {
        didSet {
            iconLabel?.textColor = iconColor
        }
    }
    
    @IBInspectable
    var icon: String? {
        didSet {
            iconLabel?.text = icon
        }
    }
    
    @IBInspectable
    var text: String? {
        didSet {
            textLabel?.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    fileprivate func setupView() {
        loadXIB()
        
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1.0
    }
}
