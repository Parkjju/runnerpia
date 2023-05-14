//
//  SceneDelegate.swift
//  runnerpia
//
//  Created by Jun on 2023/05/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
 
        guard let window else { return }
        MainViewManager.shared.show(in: window)
        window.makeKeyAndVisible()
        
    }

}

