//
//  SceneDelegate.swift
//  ReachNews
//
//  Created by Felipe Scarpitta on 28/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Avoid layout logs on console
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.makeKeyAndVisible()
        
        let newsListViewModel: NewsListViewModel = NewsListViewModel()
        
        #if DEBUG
        if let mockNewsFileName = ProcessInfo.processInfo.environment["MOCK_NEWS"] {
            InjectedValues[\.newsAPIService] = MockNewsAPIService(fileName: mockNewsFileName)
        }
        #endif
        
        let newsListController = NewsListViewController(viewModel: newsListViewModel)
        self.window?.rootViewController = UINavigationController(rootViewController: newsListController)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
