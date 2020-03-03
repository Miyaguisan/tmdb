// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class MovieDetails: TMDBViewController {
    @IBOutlet private weak var thumbnailImage: UIImageView?
    @IBOutlet private weak var posterImage: UIImageView?
    @IBOutlet private weak var gradientView: VerticalGradient?
    @IBOutlet private weak var titleLabel: UILabel?
    
    var movie: Movie?
    
    deinit {
        self.movie = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func updateUI() {
        guard let movie = movie else { return }
        
        let defaultBGColor = view.backgroundColor ?? .white
        
        gradientView?.colors = [defaultBGColor.withAlphaComponent(0.0), defaultBGColor]
        gradientView?.locations = [0.0, 0.75]
        
        titleLabel?.text = movie.title
        
        if let posterURL = movie.poster_path {
            if let image = MoviePosterManager.shared.image(for: posterURL) {
                thumbnailImage?.image = image
            }
            
            // download full image
        }
    }
}
