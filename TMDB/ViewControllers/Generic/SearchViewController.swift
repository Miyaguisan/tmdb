// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let CELL_ID = "movieCell"
let PLACEHOLDER_ID = "placeholderCell"

protocol SearchViewControllerDelegate {
    func contentArray() -> Array<Any>
    func cell(for indexPath: IndexPath) -> UICollectionViewCell?
}

class SearchViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var filterSegment: UISegmentedControl?
    
    weak var searchBar: UISearchBar?
    var delegate: SearchViewControllerDelegate?
    var currentPage = 1
    
    deinit {
        delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchControl))
    }
    
    func reset() {
        currentPage = 1
        // subclass override
    }
    
    func fetchNextContentPage() {
        // subclass override
    }
    
    func updateCollection(_ success: Bool) {
        guard success else { return }
        
        currentPage += 1
        collectionView?.reloadData()
    }
    
    @IBAction func selectFilter(control: UISegmentedControl) {
        cancelSearch()
    }
    
    @IBAction func showSearchControl() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = "Show name"
        searchBar.alpha = 0.0
        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        self.searchBar = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))
        navigationController?.navigationBar.updateChildrenLayout(animations: {
            self.searchBar?.alpha = 1.0
        }, then: {
            searchBar.becomeFirstResponder()
        })
    }
    
    @IBAction func cancelSearch() {
        searchBar?.text = nil
        searchBar?.resignFirstResponder()
        navigationController?.navigationBar.updateChildrenLayout(animations: {
            self.searchBar?.alpha = 0.0
        }, then: {
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.showSearchControl))
            self.reset()
        })
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 250)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.contentArray().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate?.cell(for: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let totalItems = self.delegate?.contentArray().count, indexPath.item == (totalItems - 1) else { return }
        
        fetchNextContentPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        searchBar?.resignFirstResponder()
//
//        let movie = MovieRequestManager.shared.movies[indexPath.item]
//
//        let movieDetails = Detail()
//        movieDetails.movie = movie
//
//        navigationController?.pushViewController(movieDetails, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func getSearchText() -> String {
        return searchBar?.text?.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let searchText = getSearchText()
        if searchText.isEmpty {
            cancelSearch()
            return
        }
        
        reset()
    }
}
