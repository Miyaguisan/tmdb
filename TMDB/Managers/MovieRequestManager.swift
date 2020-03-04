// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class MovieRequestManager {
    private var isBussy = false
    private var fetchTask: URLSessionTask?
    
    var movies: [Movie]
    
    deinit {
        cancelCurrentFetch()
        clearMovies()
    }
    
    init() {
        self.movies = []
    }
    
    func clearMovies() {
        movies.removeAll()
    }
    
    func cancelCurrentFetch() {
        fetchTask?.cancel()
        fetchTask = nil
        isBussy = false
    }
    
    func fetchMovies(with parameters: String, service: String = "discover", then onComplete: @escaping (Bool) -> Void?) {
        let finalURLString = "\(TMDb_API_URL)/\(service)/movie?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)&release_date.gte=\(TMDb_MIN_DATE)&release_date.lte=\(TMDb_MAX_DATE)\(parameters)"
        guard let url = URL(string: finalURLString), isBussy == false else { return }
        
        fetchTask?.cancel()
        fetchTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil, let data = fixedJSON(from: data, parameter: "release_date") else {
                self.performCallback(callBack: onComplete, success: false)
                return
            }
            
            do {
                let page = try jsonDecoder.decode(MoviePage.self, from: data)
                self.movies.append(contentsOf: page.results)
                self.performCallback(callBack: onComplete, success: true)
            } catch {
                print(error)
                self.performCallback(callBack: onComplete, success: false)
            }
        })
        fetchTask?.resume()
    }
    
    private func performCallback(callBack: @escaping (Bool) -> Void?, success: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchTask = nil
            self?.isBussy = false
            callBack(success)
        }
    }
}

extension MovieRequestManager {
    class func fetchMovie(with movieID: Int, then onComplete: @escaping (Movie) -> Void?) -> URLSessionTask? {
        let finalURLString = "\(TMDb_API_URL)/movie/\(movieID)?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)"
        
        guard let url = URL(string: finalURLString) else { return nil }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data, let movie = try? jsonDecoder.decode(Movie.self, from: data) else { return }
            
            DispatchQueue.main.async {
                onComplete(movie)
            }
        }
        
        task.resume()
        
        return task
    }
}
