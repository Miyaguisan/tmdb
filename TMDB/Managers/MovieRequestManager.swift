// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let TMDb_MIN_DATE = "1970-01-01"
let TMDb_MAX_DATE = "2020-03-01"
let TMDb_API_KEY = "676518c5210af2425acc7d75c112e99c"
let TMDb_LANG = "en-US"
let TMDb_API_URL = "https://api.themoviedb.org/3/discover/movie?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)&release_date.gte=\(TMDb_MIN_DATE)&release_date.lte=\(TMDb_MAX_DATE)"

class MovieRequestManager: NSObject {
    static let shared = MovieRequestManager()
    
    private var isBussy = false
    private var fetchTask: URLSessionTask?
    private let jsonDecoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return jsonDecoder
    }()
    
    var movies = [Movie]()
    
    func clearMovies() {
        movies.removeAll()
    }
    
    func fetchMovies(with urlString: String, then onComplete: @escaping (Bool) -> ()) {
        guard let url = URL(string: "\(TMDb_API_URL)&\(urlString)"), isBussy == false else { return }
        
        fetchTask?.cancel()
        fetchTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, let page = try? self.jsonDecoder.decode(Page.self, from: data), error == nil else {
                self.performCallback(callBack: onComplete, success: false)
                return
            }
            
            self.movies.append(contentsOf: page.results)
            self.performCallback(callBack: onComplete, success: true)
        })
        fetchTask?.resume()
    }
    
    func performCallback(callBack: @escaping (Bool) -> (), success: Bool) {
        DispatchQueue.main.async {
            self.fetchTask = nil
            self.isBussy = false
            callBack(success)
        }
    }
}
