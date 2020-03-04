// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let MOVIE_CELL_ID = "movieCell"
let MOVIE_PLACEHOLDER_ID = "placeholderCell"
enum FilterType: String, CaseIterable {
    case name = "title.asc"
    case date = "release_date.desc"
    case rating = "vote_average.desc"
    case likes = "vote_count.desc"
}

class MovieList: TMDBViewController {
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var filterSegment: UISegmentedControl?
    @IBOutlet weak var loadingView: UIView?
    @IBOutlet weak var loadingIndicator: CircularLoadingIndicator?
    
    private var isLoading = false {
        didSet {
            loadingView?.setVisible(isLoading)
            isLoading ? loadingIndicator?.animate() : loadingIndicator?.stop()
        }
    }
    
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        loadingIndicator?.lineWidth = 4.0
        loadingIndicator?.color = .white
        collectionView?.register(UINib(nibName: "EntertainmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MOVIE_CELL_ID)
        fetchNextMoviesPage()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    func fetchNextMoviesPage() {
        let filter = FilterType.allCases[filterSegment?.selectedSegmentIndex ?? 0]
        
        let page = "&page=\(currentPage)"
        let sort = "&sort_by=\(filter.rawValue)"
        let voting = filter == .rating ? "&vote_count.gte=100" : ""
        
        MovieRequestManager.shared.fetchMovies(with: "\(page)\(sort)\(voting)", then: updateCollection(_:))
    }
    
    func updateCollection(_ success: Bool) {
        if !success {
            return
        }
        
        currentPage += 1
        collectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MOVIE_CELL_ID, for: indexPath) as! EntertainmentCollectionViewCell
        cell.movie = MovieRequestManager.shared.movies[indexPath.item]
        cell.infoType = MovieInfoType.allCases[filterSegment?.selectedSegmentIndex ?? 0]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == MovieRequestManager.shared.movies.count - 1 {
            fetchNextMoviesPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = MovieRequestManager.shared.movies[indexPath.item]
        
        let movieDetails = MovieDetails()
        movieDetails.movie = movie
        
        navigationController?.pushViewController(movieDetails, animated: true)
    }
}
