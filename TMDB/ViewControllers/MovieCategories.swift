// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class MovieCategories: UIViewController {
    var currentCategory: MovieCategoryUIButton? {
        willSet {
            currentCategory?.isSelected = false
        }
        didSet {
            currentCategory?.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func viewMovies(button: MovieCategoryUIButton) {
        currentCategory = button
    }
    
    @IBAction func viewTVShows(button: MovieCategoryUIButton) {
        currentCategory = button
    }
}
