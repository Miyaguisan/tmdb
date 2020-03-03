// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


@IBDesignable
class DesignableUIButton: UIControl {
    @IBInspectable var backgroundColorDefault: UIColor = .systemBackground
    @IBInspectable var backgroundColorHighlighted: UIColor = .systemGray
    @IBInspectable var backgroundColorSelected: UIColor = .systemGray
    
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        loadXIB()
        
        isOpaque = true
        clipsToBounds = true
        layer.cornerRadius = 8.0
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            if self.isHighlighted {
                                self.backgroundColor = self.backgroundColorHighlighted
                            }
                            else if self.isSelected {
                                self.backgroundColor = self.backgroundColorSelected
                            }
                            else {
                                self.backgroundColor = self.backgroundColorDefault
                            }
            }, completion: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            self.backgroundColor = self.isSelected ? self.backgroundColorSelected : self.backgroundColorDefault
            }, completion: nil)
        }
    }
}

