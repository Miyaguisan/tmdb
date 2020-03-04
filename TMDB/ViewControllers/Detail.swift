// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class Detail: BaseViewController {
    @IBOutlet private weak var thumbnailImage: UIImageView?
    @IBOutlet private weak var posterImage: UIImageView?
    @IBOutlet private weak var gradientView: VerticalGradient?
    @IBOutlet private weak var runtimeLabel: UILabel?
    @IBOutlet private weak var languageLabel: UILabel?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var overviewLabel: UILabel?
    @IBOutlet private weak var itemContainer: UIStackView?
    @IBOutlet private weak var releaseDateItem: EntertainmentItem?
    @IBOutlet private weak var likesItem: EntertainmentItem?
    @IBOutlet private weak var ratingItem: EntertainmentItem?
    
    var movie: Movie? = nil
    var updateRequest: URLSessionTask? = nil
    var posterRequest: URLSessionTask? = nil
    
    deinit {
        self.movie = nil
        self.updateRequest = nil
        self.posterRequest = nil
        
        removeBlurFromNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultBGColor = view.backgroundColor ?? .white
        gradientView?.colors = [defaultBGColor.withAlphaComponent(0.0), defaultBGColor]
        gradientView?.locations = [0.0, 0.5]
        
        addBlurToNavBar()
        updateMovieUI()
        
        if let movieID = movie?.id {
            updateRequest = MovieRequestManager.fetchMovie(with: movieID, then: updateMovie(_:))
        }
        
        if let posterURL = movie?.poster_path {
            if let image = PosterManager.shared.image(for: posterURL) {
                thumbnailImage?.image = image
            }
            
            posterRequest = PosterManager.shared.getPoster(for: posterURL, then: updatePoster(_:))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateItemStack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            updateRequest?.cancel()
            posterRequest?.cancel()
        }
    }
    
    private func updateItemStack() {
        let maxWidth = view.bounds.width - 60.0
        let releaseWidth = releaseDateItem?.frame.width ?? 0
        let likesWidth = likesItem?.frame.width ?? 0
        let ratingWidth = ratingItem?.frame.width ?? 0
        let spacing = itemContainer?.spacing ?? 0.0
        let totalRequiredSpace = releaseWidth + likesWidth + ratingWidth + (spacing * 2)
        
        if totalRequiredSpace > maxWidth {
            itemContainer?.axis = .vertical
            itemContainer?.alignment = .leading
            itemContainer?.distribution = .fill
        }
        else {
            itemContainer?.axis = .horizontal
            itemContainer?.alignment = .fill
            itemContainer?.distribution = .fill
        }
    }
    
    private func updateMovie(_ movie: Movie) {
        self.movie = movie
        updateRequest = nil
        itemContainer?.updateChildrenLayout(animations: {
            self.updateMovieUI()
        })
    }
    
    private func updatePoster(_ image: UIImage) {
        posterImage?.image = image
        posterImage?.setVisible(true)
        posterRequest = nil
    }
    
    private func updateMovieUI() {
        guard let movie = movie else { return }
        
        if let runtime = movie.runtime {
            runtimeLabel?.text = "\(runtime) minutes"
            runtimeLabel?.isHidden = false
        }
        
        if let language = movie.original_language {
            languageLabel?.text = "Language '\(language.uppercased())'"
            languageLabel?.isHidden = false
        }
        
        titleLabel?.text = movie.title
        overviewLabel?.text = movie.overview
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        releaseDateItem?.text = movie.release_date == nil ? "No release date yet" : dateFormatter.string(from: movie.release_date ?? Date())
        ratingItem?.text = movie.vote_average > 0.0 ? "\(movie.vote_average)" : "No rating yet"
        likesItem?.text = movie.vote_count > 0 ? "\(movie.vote_count) Likes" : "No likes yet"
    }
}
