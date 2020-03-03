// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class CategoryButton: DesignableUIButton {
    @IBInspectable
    var icon: UIImage? = nil {
        didSet {
            self.iconImageView?.image = icon
        }
    }
    
    @IBInspectable
    var title: String? = nil {
        didSet {
            self.titleLabel?.text = title
        }
    }
}

