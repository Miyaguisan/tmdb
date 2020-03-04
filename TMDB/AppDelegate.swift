// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("NOTE\n\nTo Knotion Reviewer\n\nDue to an ongoing bug with themoviedb API regarding 'release_date' values as empty strings\ninstead of null ones. I have posted a bug report on their forums:\n\nhttps://www.themoviedb.org/talk/5e5f7258357c0000192f51c6\n\nItems with this error appear out of place when sorting them by date\nThis has forced me to manually manipulate de json string to replace such errors\nThe change can be found at Global.swift line 25\n\nTHANKS!")
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
