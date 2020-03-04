// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class Categories: BaseViewController {
    @IBOutlet private weak var moviesCategoryButton: CategoryButton?
    
    var currentCategory: CategoryButton? {
        willSet {
            currentCategory?.isSelected = false
        }
        didSet {
            currentCategory?.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        currentCategory = moviesCategoryButton
    }
    
    @IBAction func viewMovies(button: CategoryButton) {
        guard currentCategory != button, let vc = (view.window?.windowScene?.delegate as? SceneDelegate)?.moviesDetail else { return }
        
        currentCategory = button
        splitViewController?.showDetailViewController(vc, sender: nil)
    }
    
    @IBAction func viewTVShows(button: CategoryButton) {
        guard currentCategory != button, let vc = (view.window?.windowScene?.delegate as? SceneDelegate)?.showsDetail else { return }
        
        currentCategory = button
        splitViewController?.showDetailViewController(vc, sender: nil)
    }
}
