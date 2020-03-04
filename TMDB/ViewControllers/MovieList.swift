// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

enum MovieFilterType: String, CaseIterable {
    case name = "title.asc"
    case date = "release_date.desc"
    case rating = "vote_average.desc"
    case likes = "vote_count.desc"
}

class MovieList: SearchViewController {
    var requestManager = MovieRequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        delegate = self
        collectionView?.register(UINib(nibName: "EntertainmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CELL_ID)
        fetchNextContentPage()
    }
    
    override func reset() {
        super.reset()
        
        requestManager.cancelCurrentFetch()
        requestManager.clearMovies()
        collectionView?.reloadData()
        fetchNextContentPage()
    }
    
    override func fetchNextContentPage() {
        super.fetchNextContentPage()
        
        let filter = MovieFilterType.allCases[filterSegment?.selectedSegmentIndex ?? 0]
        let searchText = getSearchText()
        let page = "&page=\(currentPage)"
        let sort = "&sort_by=\(filter.rawValue)"
        let voting = filter == .rating ? "&vote_count.gte=100" : ""
        let query = searchText.isEmpty ? "" : "&query=\(searchText)"
        let parameters = "\(page)\(sort)\(voting)\(query)"
        
        requestManager.fetchMovies(with: parameters, service: searchText.isEmpty ? "discover" : "search", then: updateCollection(_:))
    }
}

extension MovieList: SearchViewControllerDelegate {
    func contentArray() -> Array<Any> {
        return requestManager.movies
    }
    
    func cell(for indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EntertainmentCollectionViewCell
        cell?.movie = requestManager.movies[indexPath.item]
        cell?.infoType = InfoType.allCases[filterSegment?.selectedSegmentIndex ?? 0]

        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let details = Detail()
        details.movie = requestManager.movies[indexPath.item]
        
        navigationController?.pushViewController(details, animated: true)
    }
}
