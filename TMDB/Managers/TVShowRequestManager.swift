// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class TVShowRequestManager {
    private var isBussy = false
    private var fetchTask: URLSessionTask?
    
    var shows: [TVShow]
    
    deinit {
        cancelCurrentFetch()
        clearShows()
    }
    
    init() {
        self.shows = []
    }
    
    func clearShows() {
        shows.removeAll()
    }
    
    func cancelCurrentFetch() {
        fetchTask?.cancel()
        fetchTask = nil
        isBussy = false
    }
    
    func fetchShows(with parameters: String, service: String = "discover", then onComplete: @escaping (Bool) -> Void?) {
        let finalURLString = "\(TMDb_API_URL)/\(service)/tv?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)&include_null_first_air_dates=false&first_air_date.gte=\(TMDb_MIN_DATE)&first_air_date.lte=\(TMDb_MAX_DATE)\(parameters)"
        guard let url = URL(string: finalURLString), isBussy == false else { return }
        
        fetchTask?.cancel()
        fetchTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil, let data = fixedJSON(from: data, parameter: "first_air_date") else {
                self.performCallback(callBack: onComplete, success: false)
                return
            }
            
            do {
                let page = try jsonDecoder.decode(TVShowPage.self, from: data)
                self.shows.append(contentsOf: page.results)
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

extension TVShowRequestManager {
    class func fetchShow(with showID: Int, then onComplete: @escaping (TVShow) -> Void?) -> URLSessionTask? {
        let finalURLString = "\(TMDb_API_URL)/tv/\(showID)?api_key=\(TMDb_API_KEY)&language=\(TMDb_LANG)"
        guard let url = URL(string: finalURLString) else { return nil }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = fixedJSON(from: data, parameter: "first_air_date") else { return }
            
            do {
                let show = try jsonDecoder.decode(TVShow.self, from: data)
                DispatchQueue.main.async {
                    onComplete(show)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
        return task
    }
}
