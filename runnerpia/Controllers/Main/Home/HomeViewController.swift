//
//  HomeViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var homeView = HomeView()
    let locationManager = UserLocationManager.shared

    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func loadView() {
        view = homeView
    }
    
    
    // MARK: - Selectors
    
    @objc private func searchButtonTapped() {
        let searchViewController = SearchViewController()
        searchViewController.hidesBottomBarWhenPushed = true // 탭 바 나타나지 않도록 설정
//        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    
    // MARK: - Helpers
    
    func configureUI(){
        requestLocationPermissionAuthorization()
    }
    
    func requestLocationPermissionAuthorization(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func configureNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 0, width: 79, height: 24)
        let logoBarButton = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoBarButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }

}
