//
//  HomeViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var homeView = HomeView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        
    }
    
    override func loadView() {
        view = homeView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .mainBlue
    }
    
    private func configureDelegate() {
        //        signInView.delegate = self
    }
    
    // MARK: - Layout Extension
}
