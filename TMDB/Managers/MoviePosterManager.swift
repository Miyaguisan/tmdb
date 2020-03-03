// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

let STATIC_TMDB_URL = "https://image.tmdb.org/t/p/w200"

class MoviePosterManager: NSObject {
    static let shared = MoviePosterManager()
    var images = [String:Any]()
    
    func image(for urlString: String) -> UIImage? {
        return images[urlString] as? UIImage
    }
    
    func downloadImage(for urlString: String, then onComplete: @escaping (String, UIImage?) -> ()) {
        guard !images.keys.contains(urlString) else { return }
        
        let finalURL = "\(STATIC_TMDB_URL)\(urlString)"
        guard let url = URL(string: finalURL) else {
            onComplete(urlString, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.images[urlString] = image
                    onComplete(urlString, image)
                }
                
                return
            }
            else {
                self.images.removeValue(forKey: urlString)
            }
        }
        
        images[urlString] = task
        task.resume()
    }
}
