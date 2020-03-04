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

let numberFormatter = NumberFormatter()

let ANIMATION_ENTER_DURATION = 0.195
let TMDb_MIN_DATE = "1970-01-01"
let TMDb_MAX_DATE = "2020-03-01"
let TMDb_API_KEY = "676518c5210af2425acc7d75c112e99c"
let TMDb_LANG = "en-US"
let TMDb_API_URL = "https://api.themoviedb.org/3"
