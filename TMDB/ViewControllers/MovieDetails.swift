// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class MovieDetails: TMDBViewController {
    @IBOutlet private weak var thumbnailImage: UIImageView?
    @IBOutlet private weak var posterImage: UIImageView?
    
    var movie: Movie?
    
    deinit {
        self.movie = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        guard let movie = movie else { return }
        
        if let posterURL = movie.poster_path {
            if let image = MoviePosterManager.shared.image(for: posterURL) {
                thumbnailImage?.image = image
            }
            
            // download full image
        }
    }
}
