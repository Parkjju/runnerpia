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
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func configureDelegate() {
        searchView.searchBar.delegate = self
        locationManager.delegate = self
        searchView.delegate = self
    }
    
}

// MARK: - extension SearchBar

extension SearchViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        searchView.searchBar.placeholder = "시/구까지 입력해주세요."
        searchView.searchBar.showsCancelButton = true
        searchView.searchBar.backgroundImage = UIImage() // 상, 하단 줄 해제
        if let cancelButton = searchView.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("", for: .normal)
            let cancelButtonImage = UIImage(named: "cancelButton")?.withRenderingMode(.alwaysOriginal)
            cancelButton.setImage(cancelButtonImage, for: .normal)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - extension Map

extension SearchViewController: CLLocationManagerDelegate {

    
    private func configureMap() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        //        searchView.map.showLocationButton = true
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() // 현재 위치를 가져옴
            print(locationManager.location?.coordinate)
            
            // 현 위치로 카메라 이동
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            searchView.map.moveCamera(cameraUpdate)
            
            // 마커
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0)
            marker.mapView = searchView.map
            
            
            // ⚠️ 추후수정
            let particularRouteController = ParticularRouteController()
            let data = particularRouteController.setupData()
            let leftLabelText = "2"
            let rightLabelText = data.distance
    
            
            let viewMarker: UIView = {
                let locationMarker = UIImageView() // 최소 사이즈 설정
                locationMarker.image = UIImage(named: "marker")
                locationMarker.contentMode = .scaleAspectFit
                
                locationMarker.sizeToFit() // 이미지의 원본 크기에 맞게 이미지 뷰의 크기 조정
                
                let leftLabel = UILabel(frame: CGRect(x: 4, y: 2, width: 49, height: 20))
                leftLabel.text = "\(leftLabelText)"
                leftLabel.textColor = .white
                leftLabel.textAlignment = .center
                leftLabel.font = .regular12
                locationMarker.addSubview(leftLabel)
                
                let middleLabel = UILabel(frame: CGRect(x: 13, y: 2, width: 49, height: 20))
                middleLabel.text = "|"
                middleLabel.textColor = .markerColorGreen
                middleLabel.textAlignment = .center
                middleLabel.font = .regular12
                locationMarker.addSubview(middleLabel)
                
                let rightLabel = UILabel(frame: CGRect(x: 33, y: 2, width: 49, height: 20))
                
                if let unwrappedDistance = rightLabelText {
                    rightLabel.text = "\(unwrappedDistance)km"
                } else {
                    rightLabel.text = ""
                }
                
                rightLabel.textColor = .markerColorGreen
                rightLabel.textAlignment = .center
                rightLabel.font = .regular12
                locationMarker.addSubview(rightLabel)

                return locationMarker
            }()
            
            marker.iconImage = NMFOverlayImage(image: viewMarker.asImage())
            
        
            // 오버레이
            let locationOverlay = searchView.map.locationOverlay
            locationOverlay.icon = NMFOverlayImage(name: "myLocation")
            
        } else {
            print("위치 서비스 Off 상태")
        }
    }


    
}


// MARK: - Delegate

extension SearchViewController: SearchViewDelegate {
    
    
    func locationButtonTapped(_ searchView: SearchView) {
        print("locationButtonTapped !! ")
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)
        

//        locationManager.startUpdatingLocation()
//        let cameraUpdate = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0)
//        searchView.map.moveCamera(cameraUpdate)

        
    }
    
    
}

    

