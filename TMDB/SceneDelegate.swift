// Created for TMDB in 2020
// Using Swift 5.0
// Running on macOS 10.15

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var master = UINavigationController(rootViewController: Categories())
    var moviesDetail = UINavigationController(rootViewController: MovieList())
    var showsDetail = UINavigationController(rootViewController: TVShowList())
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let svc = UISplitViewController()
        svc.viewControllers = [master, moviesDetail]
        svc.preferredDisplayMode = .allVisible
        window?.rootViewController = svc
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
