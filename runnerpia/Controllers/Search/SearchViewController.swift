//
//  SearchViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//


import UIKit
import NMapsMap
import CoreLocation

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var searchView = SearchView()
    var locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        configureSearchBar()
        configureMap()
    }
    
    override func loadView() {
        view = searchView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureDelegate() {
        searchView.searchBar.delegate = self
        locationManager.delegate = self
    }

}

// MARK: - extension SearchBar

extension SearchViewController: UISearchBarDelegate {
    private func configureSearchBar() {
        searchView.searchBar.placeholder = "시/구까지 입력해주세요."
        searchView.searchBar.showsCancelButton = true
        searchView.searchBar.backgroundImage = UIImage() // 상, 하단 줄 해제
    }
}

// MARK: - extension Map

extension SearchViewController: CLLocationManagerDelegate {
    
    private func configureMap() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)
            
            //현 위치로 카메라 이동
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            searchView.map.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0)
            marker.mapView = searchView.map
            
        } else {
            print("위치 서비스 Off 상태")
        }
    }
}
