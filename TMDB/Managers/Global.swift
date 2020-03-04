// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en-US")
    df.dateFormat = "MMM dd yyyy"
    
    return df
}()

let jsonDecoder: JSONDecoder = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"

    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .useDefaultKeys
    jsonDecoder.dateDecodingStrategy = .formatted(df)

    return jsonDecoder
}()

let numberFormatter = NumberFormatter()

let ANIMATION_ENTER_DURATION = 0.195
let STATIC_TMDB_URL = "https://image.tmdb.org/t/p"
let TMDb_MIN_DATE = "1970-01-01"
let TMDb_MAX_DATE = "2020-03-01"
let TMDb_API_KEY = "676518c5210af2425acc7d75c112e99c"
let TMDb_LANG = "en-US"
let TMDb_TIMEZONE = "America%2FNew_York"
let TMDb_API_URL = "https://api.themoviedb.org/3"

func fixedJSON(from source: Data?, parameter: String) -> Data? {
    guard let data = source else { return nil }
    
    return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\"\(parameter)\":\"\"", with: "\"\(parameter)\":null").data(using: .utf8)
}
