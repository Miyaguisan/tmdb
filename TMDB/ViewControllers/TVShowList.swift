// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


enum TVShowFilterType: String, CaseIterable {
    case name = "name.asc"
    case date = "first_air_date.desc"
    case rating = "vote_average.desc"
    case likes = "vote_count.desc"
}

class TVShowList: SearchViewController {
    var requestManager = TVShowRequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TV Shows"
        delegate = self
        collectionView?.register(UINib(nibName: "EntertainmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CELL_ID)
        fetchNextContentPage()
    }
    
    override func reset() {
        super.reset()
        
        requestManager.cancelCurrentFetch()
        requestManager.clearShows()
        collectionView?.reloadData()
        fetchNextContentPage()
    }
    
    override func fetchNextContentPage() {
        super.fetchNextContentPage()
        
        let filter = TVShowFilterType.allCases[filterSegment?.selectedSegmentIndex ?? 0]
        let searchText = getSearchText()
        let page = "&page=\(currentPage)"
        let voting = filter == .rating ? "&vote_count.gte=100" : ""
        let sort = "&sort_by=\(filter.rawValue)"
        let query = searchText.isEmpty ? "" : "&query=\(searchText)"
        let parameters = "\(page)\(sort)\(voting)\(query)"
        
        requestManager.fetchShows(with: parameters, service: searchText.isEmpty ? "discover" : "search", then: updateCollection(_:))
    }
}

extension TVShowList: SearchViewControllerDelegate {
    func contentArray() -> Array<Any> {
        return requestManager.shows
    }
    
    func cell(for indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? EntertainmentCollectionViewCell
        cell?.show = requestManager.shows[indexPath.item]
        cell?.infoType = InfoType.allCases[filterSegment?.selectedSegmentIndex ?? 0]
        
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let details = Detail()
        details.show = requestManager.shows[indexPath.item]
        
        navigationController?.pushViewController(details, animated: true)
    }
}
