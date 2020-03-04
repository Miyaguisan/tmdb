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
        df.dateFormat = "yyyy-mm-dd"
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        jsonDecoder.dateDecodingStrategy = .formatted(df)
        
        return jsonDecoder
    }()
    
    var movies = [Movie]()
    
    func clearMovies() {
        movies.removeAll()
    }
    
    func fetchMovies(with urlString: String, then onComplete: @escaping (Bool) -> ()) {
        guard let url = URL(string: "\(TMDb_API_URL)\(urlString)"), isBussy == false else { return }
        
        fetchTask?.cancel()
        fetchTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, let page = try? self.jsonDecoder.decode(MoviePage.self, from: data), error == nil else {
                self.performCallback(callBack: onComplete, success: false)
                return
            }
            
            self.movies.append(contentsOf: page.results)
            self.performCallback(callBack: onComplete, success: true)
        })
        fetchTask?.resume()
    }
    
    func fetchMovie(with movieID: Int, then onComplete: @escaping (Movie) -> ()) -> URLSessionTask? {
        guard let url = URL(string: "\(TMDb_API_SINGLE_URL)\(movieID)?api_key=\(TMDb_API_KEY)&language=en-US") else { return nil }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let movie = try self.jsonDecoder.decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    onComplete(movie)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        return task
    }
    
    private func performCallback(callBack: @escaping (Bool) -> (), success: Bool) {
        DispatchQueue.main.async {
            self.fetchTask = nil
            self.isBussy = false
            callBack(success)
        }
    }
}
