// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let MOVIE_CELL_ID = "movieCell"
let MOVIE_PLACEHOLDER_ID = "placeholderCell"
enum FilterType: String, CaseIterable {
    case name = "title.asc"
    case date = "release_date.desc"
    case rating = "popularity.desc"
    case likes = "vote_count.desc"
}

class MovieList: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var networkErrorAlert: UIView!
    
    private var networkError = false {
        didSet {
            collectionView.isHidden = networkError
            networkErrorAlert.isHidden = !networkError
        }
    }
    
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MOVIE_CELL_ID)
        fetchNextMoviesPage()
    }
    
    func fetchNextMoviesPage() {
        let page = "page=\(currentPage)"
        let filter = "sort_by=\(FilterType.allCases[filterSegment.selectedSegmentIndex].rawValue)"
        
        MovieRequestManager.shared.fetchMovies(with: "\(page)&\(filter)", then: updateCollection(_:))
    }
    
    func updateCollection(_ success: Bool) {
        if !success {
            return
        }
        
        currentPage += 1
        collectionView.reloadData()
    }
    
    @IBAction func selectFilter(control: UISegmentedControl) {
        currentPage = 1
        MovieRequestManager.shared.clearMovies()
        fetchNextMoviesPage()
    }
}

extension MovieList: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 250)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieRequestManager.shared.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MOVIE_CELL_ID, for: indexPath) as! MovieCollectionViewCell
        cell.movie = MovieRequestManager.shared.movies[indexPath.item]
        cell.showLikes = filterSegment.selectedSegmentIndex == 3
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == MovieRequestManager.shared.movies.count - 1 {
            fetchNextMoviesPage()
        }
    }
}
