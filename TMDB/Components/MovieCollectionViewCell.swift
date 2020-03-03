// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let NEW_RELEASE_MAX_DAYS = 40

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var thumbnailImageView: UIImageView?
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var isNewReleaseIndicator: UIImageView?
    @IBOutlet private weak var isLoadingIndicator: CircularLoadingIndicator?
    @IBOutlet private weak var likesContainer: UIView?
    @IBOutlet private weak var likesLabel: UILabel?
    
    private let numberFormatter = NumberFormatter()
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            likesLabel?.text = "\(numberFormatter.string(from: NSNumber(value:movie.vote_count)) ?? "") Likes"
            titleLabel?.text = movie.title
            isNewReleaseIndicator?.isHidden = daysSince(date: movie.release_date) > NEW_RELEASE_MAX_DAYS
            
            if let posterURL = movie.poster_path {
                if let image = MoviePosterManager.shared.image(for: posterURL) {
                    thumbnailImageView?.image = image
                    thumbnailImageView?.isHidden = false
                    isLoadingIndicator?.stop()
                }
                else {
                    isLoadingIndicator?.animate()
                    thumbnailImageView?.isHidden = true
                    MoviePosterManager.shared.downloadImage(for: posterURL, then: updateImage(_:_:))
                }
            }
            else {
                updateImage("", nil)
            }
        }
    }
    
    var showLikes: Bool = false {
        didSet {
            likesContainer?.isHidden = !showLikes
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberFormatter.numberStyle = .decimal
        setupCell()
    }
    
    private func setupCell() {
        containerView?.addDropShadow()
    }
    
    private func updateImage(_ source: String, _ image: UIImage?) {
        thumbnailImageView?.isHidden = false
        isLoadingIndicator?.stop()
        
        guard source == movie?.poster_path, let image = image else {
            thumbnailImageView?.image = UIImage(named: "missing_cover")
            return
        }
        
        thumbnailImageView?.image = image
    }
    
    private func daysSince(date: Date?) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date ?? Date(), to: Date())
        
        return components.day ?? 0
    }
}
