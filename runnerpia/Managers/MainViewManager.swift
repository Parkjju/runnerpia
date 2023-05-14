//
//  MainViewManager.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit

class MainViewManager {
    
    // MARK: - Properties
    
    static let shared = MainViewManager()
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    // MARK: - LifeCycle
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        setTapBarController()
        
        // 로그인메서드
    }

    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func setTapBarController() {
        let tabBarViewController = UITabBarController()
        
        let vc1 = UINavigationController(rootViewController: RouteViewController())
        let vc2 = UINavigationController(rootViewController: MyPageViewController())
        
        tabBarViewController.setViewControllers([vc1, vc2], animated: false)
        tabBarViewController.modalPresentationStyle = .fullScreen
        tabBarViewController.tabBar.backgroundColor = .white
        tabBarViewController.tabBar.tintColor = .black
        
        guard let items = tabBarViewController.tabBar.items else { return }
        items[0].image = UIImage(named: "Route")
        items[0].selectedImage = UIImage(named: "Route")
        items[0].title = "경로 따라가기"
        items[1].image = UIImage(named: "Mypage")
        items[1].selectedImage = UIImage(named: "Mypage")
        items[1].title = "마이"
        
        tabBarViewController.selectedIndex = 0
        tabBarViewController.tabBar.backgroundColor = .white
        rootViewController = tabBarViewController
    }



}
