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
        requestLocationPermissionAuthorization()
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

extension SearchViewController: CLLocationManagerDelegate, UISheetPresentationControllerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)
    }

    
    private func configureMap() {
        // 마커
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.2785, lng: 127.1440)
        marker.mapView = searchView.map
        
        // ⚠️ 추후수정
        let particularRouteController = ParticularRouteController()
        let data = particularRouteController.setupData()
        let leftLabelText = "2"
        let rightLabelText = data.distance

        
        let viewMarker: UIImageView = {
            let locationMarker = UIImageView() // 최소 사이즈 설정
            locationMarker.image = UIImage(named: "marker_plain")
            locationMarker.contentMode = .scaleAspectFit
            locationMarker.sizeToFit() // 이미지의 원본 크기에 맞게 이미지 뷰의 크기 조정
            
            
            let checkImage = UIImageView(image: UIImage(named: "check"))
            checkImage.sizeToFit()
            locationMarker.addSubview(checkImage)
            
            // MARK: position기반으로 위치가 지정되는 NMFMarker는 오토레이아웃으로 레이아웃 설정이 불가능
            checkImage.frame.origin.y = locationMarker.frame.minY + 5
            checkImage.frame.origin.x = locationMarker.frame.minX + 8
            
            let leftLabel = UILabel()
            leftLabel.font = .regular12
            leftLabel.text = "\(leftLabelText)"
            leftLabel.sizeToFit()
            leftLabel.textColor = .white
            leftLabel.frame.origin.x = checkImage.frame.maxX + 5
            leftLabel.center.y = checkImage.center.y + 1
            locationMarker.addSubview(leftLabel)
            
            let middleLabel = UILabel()
            middleLabel.text = "|"
            middleLabel.textColor = .markerColorGreen
            middleLabel.font = .regular12
            middleLabel.sizeToFit()
            middleLabel.frame.origin.x = leftLabel.frame.maxX + 5
            middleLabel.center.y = leftLabel.center.y
            locationMarker.addSubview(middleLabel)
            
            
            let rightLabel = UILabel()
            if let unwrappedDistance = rightLabelText {
                rightLabel.text = "\(unwrappedDistance)km"
            } else {
                rightLabel.text = ""
            }
            
            rightLabel.textColor = .markerColorGreen
            rightLabel.font = .regular12
            rightLabel.sizeToFit()
            rightLabel.frame.origin.x = middleLabel.frame.maxX + 5
            rightLabel.center.y = leftLabel.center.y
            locationMarker.addSubview(rightLabel)
            
            if(rightLabel.frame.maxX + 5 > locationMarker.frame.maxX){
                let diff = (rightLabel.frame.maxX + 5) - locationMarker.frame.maxX

                // MARK: 너비 + diff값으로 locationMarker 이미지 크기 확대
                // MARK: 상수값으로 확대하는건 가능
                // MARK: 로직에 맞춰 확대하는건
                locationMarker.image = locationMarker.image?.scaleWithoutPreserveAspectRatio(targetValue: locationMarker.frame.width + diff + 5, originalValue: locationMarker.frame.height, axis: .horizontal)
            }
            return locationMarker
        }()
        
        viewMarker.sizeToFit()
        
        // MARK: 마커 여러개 어떻게 표현할지 -> 네이버지도 문서에 따르면 메모리 문제 발생 가능성 존재
        marker.iconImage = NMFOverlayImage(image: viewMarker.asImage())
        
        // Marker 터치이벤트
        marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
            print("마커 터치됨")
            
            let halfModalViewController = HalfModalPresentationController()
            halfModalViewController.modalPresentationStyle = .pageSheet
            
            if let sheet = halfModalViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.delegate = self
                sheet.prefersGrabberVisible = true
            }

            present(halfModalViewController, animated: true, completion: nil)
            
            return true
        }
        
    
        // 오버레이
        let locationOverlay = searchView.map.locationOverlay
        locationOverlay.icon = NMFOverlayImage(name: "myLocation")
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
    
    func requestLocationPermissionAuthorization(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
}

    

