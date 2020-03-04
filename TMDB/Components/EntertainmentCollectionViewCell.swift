// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let NEW_RELEASE_MAX_DAYS = 7
enum MovieInfoType: Int, CaseIterable {
    case none = 0
    case date
    case rating
    case likes
}

class EntertainmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var thumbnailImageView: UIImageView?
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var isNewReleaseIndicator: UIImageView?
    @IBOutlet private weak var isLoadingIndicator: CircularLoadingIndicator?
    @IBOutlet private weak var badgeContainer: UIView?
    @IBOutlet private weak var badgeCoutLabel: UILabel?
    @IBOutlet private weak var badgeIconLabel: UILabel?
    
    private final let infoTypeColor = [
        MovieInfoType.date: UIColor.systemGreen,
        MovieInfoType.likes: UIColor.systemPink,
        MovieInfoType.rating: UIColor.systemOrange
    ]
    private final let infoTypeFormat = [
        MovieInfoType.likes: NumberFormatter.Style.decimal
    ]
    private final let infoTypeIcon = [
        MovieInfoType.date: "",
        MovieInfoType.likes: "",
        MovieInfoType.rating: ""
    ]
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
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
                    MoviePosterManager.shared.getThumbnail(for: posterURL, then: updateImage(_:_:))
                }
            }
            else {
                updateImage("", nil)
            }
        }
    }
    
    var infoType = MovieInfoType.none {
        didSet {
            guard infoType != .none else {
                badgeContainer?.isHidden = true
                return
            }
            
            badgeContainer?.isHidden = false
            badgeContainer?.backgroundColor = infoTypeColor[infoType]
            badgeIconLabel?.text = infoTypeIcon[infoType]
            numberFormatter.numberStyle = infoTypeFormat[infoType] ?? .none
            
            switch infoType {
            case .date:
                let date = movie?.release_date ?? Date()
                badgeCoutLabel?.text = dateFormatter.string(from: date).capitalized
                break
            case .likes:
                let likes = movie?.vote_count ?? 0
                badgeCoutLabel?.text = "\(numberFormatter.string(from: NSNumber(value:likes)) ?? "") Likes"
                break
            case .rating:
                let rating = movie?.vote_average ?? 0.0 * 100.0
                badgeCoutLabel?.text = "\(rating)"
                break
            default: break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
