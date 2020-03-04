// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class MovieRequestManager: NSObject {
    static let shared = MovieRequestManager()
    
    private var isBussy = false
    private var fetchTask: URLSessionTask?
    private let jsonDecoder: JSONDecoder = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        jsonDecoder.dateDecodingStrategy = .formatted(df)
        
        return jsonDecoder
    }()
    
    var movies = [Movie]()
    
    func clearMovies() {
        movies.removeAll()
    }
    
    func fetchMovies(with urlString: String, service: String = "discover", then onComplete: @escaping (Bool) -> ()) {
        let finalURLString = "\(TMDb_API_URL)/\(service)/movie?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)&release_date.gte=\(TMDb_MIN_DATE)&release_date.lte=\(TMDb_MAX_DATE)\(urlString)"
        
        guard let url = URL(string: finalURLString), isBussy == false else { return }
        
        fetchTask?.cancel()
        fetchTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil, let data = MovieRequestManager.fixedJSON(from: data) else {
                self.performCallback(callBack: onComplete, success: false)
                return
            }
            
            do {
                let page = try self.jsonDecoder.decode(MoviePage.self, from: data)
                self.movies.append(contentsOf: page.results)
                self.performCallback(callBack: onComplete, success: true)
            } catch {
                print(error)
                self.performCallback(callBack: onComplete, success: false)
            }
        })
        fetchTask?.resume()
    }
    
    func cancelCurrentFetch() {
        fetchTask?.cancel()
        fetchTask = nil
        isBussy = false
    }
    
    func fetchMovie(with movieID: Int, then onComplete: @escaping (Movie) -> ()) -> URLSessionTask? {
        let finalURLString = "\(TMDb_API_URL)/movie/\(movieID)?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)"
        
        guard let url = URL(string: finalURLString) else { return nil }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data, let movie = try? self.jsonDecoder.decode(Movie.self, from: data) else { return }
            
            DispatchQueue.main.async {
                onComplete(movie)
            }
        }
        
        task.resume()
        
        return task
    }
    
    private func performCallback(callBack: @escaping (Bool) -> (), success: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchTask = nil
            self?.isBussy = false
            callBack(success)
        }
    }
    
    class func fixedJSON(from source: Data?) -> Data? {
        guard let data = source else { return nil }
        
        return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\"release_date\":\"\"", with: "\"release_date\":null").data(using: .utf8)
    }
}
