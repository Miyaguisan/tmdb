// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let NEW_RELEASE_MAX_DAYS = 7
enum InfoType: Int, CaseIterable {
    case none = 0
    case date
    case rating
    case likes
    
    var color: UIColor {
        switch self {
        case .date: return .systemGreen
        case .likes: return .systemPink
        case .rating: return .systemOrange
        default: return .clear
        }
    }
    
    var format: NumberFormatter.Style {
        switch self {
        case .likes: return .decimal
        default: return .none
        }
    }
    
    var icon: String {
        switch self {
        case .date: return ""
        case .likes: return ""
        case .rating: return ""
        default: return ""
        }
    }
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
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            titleLabel?.text = movie.title
            isNewReleaseIndicator?.isHidden = daysSince(date: movie.release_date) > NEW_RELEASE_MAX_DAYS
            setImage(from: movie.poster_path)
        }
    }
    
    var show: TVShow? {
        didSet {
            guard let show = show else { return }
            
            titleLabel?.text = show.original_name
            isNewReleaseIndicator?.isHidden = daysSince(date: show.first_air_date) > NEW_RELEASE_MAX_DAYS
            setImage(from: show.poster_path)
        }
    }
    
    var infoType = InfoType.none {
        didSet {
            guard infoType != .none else {
                badgeContainer?.isHidden = true
                return
            }
            
            badgeContainer?.isHidden = false
            badgeContainer?.backgroundColor = infoType.color
            badgeIconLabel?.text = infoType.icon
            numberFormatter.numberStyle = infoType.format
            
            switch infoType {
            case .date:
                let date = movie?.release_date ?? show?.first_air_date ?? Date()
                badgeCoutLabel?.text = dateFormatter.string(from: date).capitalized
                break
            case .likes:
                let likes = movie?.vote_count ?? show?.vote_count ?? 0
                badgeCoutLabel?.text = "\(numberFormatter.string(from: NSNumber(value:likes)) ?? "") Likes"
                break
            case .rating:
                let rating = movie?.vote_average ?? show?.vote_average ?? 0.0 * 100.0
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
    
    private func setImage(from url: String?) {
        if let url = url {
            if let image = PosterManager.shared.image(for: url) {
                thumbnailImageView?.image = image
                thumbnailImageView?.isHidden = false
                isLoadingIndicator?.stop()
            }
            else {
                isLoadingIndicator?.animate()
                thumbnailImageView?.isHidden = true
                PosterManager.shared.getThumbnail(for: url, then: updateImage(_:_:))
            }
        }
        else {
            updateImage("", nil)
        }
    }
    
    private func updateImage(_ source: String, _ image: UIImage?) {
        thumbnailImageView?.isHidden = false
        isLoadingIndicator?.stop()
        
        if let image = image, source == movie?.poster_path || source == show?.poster_path {
            thumbnailImageView?.image = image
        }
        else {
            thumbnailImageView?.image = UIImage(named: "missing_cover")
        }
    }
    
    private func daysSince(date: Date?) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date ?? Date(), to: Date())
        
        return components.day ?? 0
    }
}
