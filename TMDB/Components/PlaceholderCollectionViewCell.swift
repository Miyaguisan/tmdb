// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class PlaceholderCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var placeholder: AnimatedPlaceholderBackgroundView?
    
    var index: Int = 0 {
        didSet {
            placeholder?.stop()
            placeholder?.animate()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView?.addDropShadow()
    }
}
