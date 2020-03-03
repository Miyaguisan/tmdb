// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class MovieCategories: UIViewController {
    @IBOutlet private weak var moviesCategoryButton: MovieCategoryUIButton?
    
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
        
        self.title = "Categories"
        currentCategory = moviesCategoryButton
    }
    
    @IBAction func viewMovies(button: MovieCategoryUIButton) {
        guard currentCategory != button else { return }
        
        currentCategory = button
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: MovieList()), sender: nil)
    }
    
    @IBAction func viewTVShows(button: MovieCategoryUIButton) {
        guard currentCategory != button else { return }
        
        currentCategory = button
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: MovieDetails()), sender: nil)
    }
}
