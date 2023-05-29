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
    
    private var searchController = UISearchController(searchResultsController: nil)

    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func loadView() {
        view = homeView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigationBar() {
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 0, width: 79, height: 24)
        let logoBarButton = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoBarButton
        
        // ⚠️ 서치 버튼 누른 후 행동 추가해야 함
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
        
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    
    
}
