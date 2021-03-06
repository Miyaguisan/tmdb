// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let CELL_ID = "movieCell"
let PLACEHOLDER_ID = "placeholderCell"

protocol SearchViewControllerDelegate {
    func contentArray() -> Array<Any>
    func cell(for indexPath: IndexPath) -> UICollectionViewCell?
    func didSelectItem(at indexPath: IndexPath)
}

class SearchViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var filterSegment: UISegmentedControl?
    @IBOutlet weak var loadingIndicator: CircularLoadingIndicator?
    
    weak var searchBar: UISearchBar?
    var delegate: SearchViewControllerDelegate?
    var currentPage = 1
    
    deinit {
        delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator?.color = .systemBlue
        loadingIndicator?.lineWidth = 4
        
        definesPresentationContext = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchControl))
        
        collectionView?.register(UINib(nibName: "PlaceholderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PLACEHOLDER_ID)
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
        loadingIndicator?.stop()
    }
    
    @IBAction func selectFilter(control: UISegmentedControl) {
        loadingIndicator?.animate()
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
        if let totalItems = self.delegate?.contentArray().count, totalItems > 0 {
            return totalItems
        }
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = delegate?.cell(for: indexPath) {
            return cell
        }
        
        let placeholderCell = collectionView.dequeueReusableCell(withReuseIdentifier: PLACEHOLDER_ID, for: indexPath) as! PlaceholderCollectionViewCell
        placeholderCell.index = indexPath.item
        
        return placeholderCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let totalItems = self.delegate?.contentArray().count, totalItems > 0, indexPath.item == (totalItems - 1) else { return }
        
        fetchNextContentPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let totalItems = self.delegate?.contentArray().count, totalItems > 0 else { return }
        
        searchBar?.resignFirstResponder()
        delegate?.didSelectItem(at: indexPath)
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
