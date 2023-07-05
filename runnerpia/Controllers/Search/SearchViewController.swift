//
//  SearchViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//


import UIKit
import NMapsMap
import CoreLocation

final class SearchViewController: UIViewController, NMFMapViewTouchDelegate {
    
    // MARK: - Properties
    
    var searchView = SearchView()
    var locationManager = CLLocationManager()
    var halfModalView = HalfModalView()
    let marker = NMFMarker()

    let pathOverlay = NMFPath()

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        requestLocationPermissionAuthorization()
        
    }
    
    override func loadView() {
        view = searchView
    }
    
    
    // MARK: - Selectors
    
    @objc private func cancelButtonButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "경로 검색"
        navigationItem.setHidesBackButton(true, animated: false)

        let cancelButton = UIImage(named: "cancelButton")
        let cancelButtonTapped = UIBarButtonItem(image: cancelButton, style: .plain, target: self, action: #selector(cancelButtonButtonTapped))
        navigationItem.rightBarButtonItem = cancelButtonTapped
    }
    
    private func configureDelegate() {
        locationManager.delegate = self
        searchView.delegate = self
        searchView.map.touchDelegate = self
    }
    
}


// MARK: - extension Map

extension SearchViewController: CLLocationManagerDelegate, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presented = presented as! HalfModalPresentationController
        presented.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2 / 3, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 1. 카메라 업데이트
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)
    }


    
//    func addMarker() {
////        marker.position = NMGLatLng(lat: data.arrayOfPos!.first!.latitude, lng: data.arrayOfPos!.first!.longitude)
//        marker.mapView = searchView.map
//
//        let viewMarker = createViewMarker()
//        marker.iconImage = NMFOverlayImage(image: viewMarker.asImage())
//
//        // 마커 터치핸들러
//        marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
//            presentHalfModal()
//            locationManager.stopUpdatingLocation()
//            searchView.map.positionMode = .disabled
//            overlay.globalZIndex = 10
//            pathOverlay.color = .white
//            pathOverlay.mapView = searchView.map
//
//            return true
//        }
//    }
    
    func createViewMarker() -> UIImageView {
        let leftLabelText = "2"
//        let rightLabelText = data.distance
        
        let locationMarker = UIImageView() // 최소 사이즈 설정
        locationMarker.image = UIImage(named: "tooltip")?.scalePreservingAspectRatio(targetSize: CGSize(width: 120, height: 50))
        locationMarker.contentMode = .scaleAspectFit
        locationMarker.sizeToFit() // 이미지의 원본 크기에 맞게 이미지 뷰의 크기 조정
        let routeNameLabel = UILabel()
        routeNameLabel.text = "경로타이틀최대10자ewjifefowi".count > 10 ? "경로타이틀최대.." : "경로타이틀최대10자"
        routeNameLabel.font = .regular12
        routeNameLabel.textColor = .white
        routeNameLabel.frame.origin.x = locationMarker.frame.minX + 8
        routeNameLabel.frame.origin.y = locationMarker.frame.minY + 5
        routeNameLabel.sizeToFit()
        locationMarker.addSubview(routeNameLabel)
        
        let checkImage = UIImageView(image: UIImage(named: "check")?.scalePreservingAspectRatio(targetSize: CGSize(width: 12, height: 14)))
        checkImage.sizeToFit()
        locationMarker.addSubview(checkImage)
        
        // MARK: position기반으로 위치가 지정되는 NMFMarker는 오토레이아웃으로 레이아웃 설정이 불가능
        checkImage.frame.origin.y = routeNameLabel.frame.maxY + 5
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
        middleLabel.textColor = .white
        middleLabel.font = .regular12
        middleLabel.sizeToFit()
        middleLabel.frame.origin.x = leftLabel.frame.maxX + 5
        middleLabel.center.y = leftLabel.center.y
        locationMarker.addSubview(middleLabel)
        
        
        let rightLabel = UILabel()
//        if let unwrappedDistance = rightLabelText {
//            rightLabel.text = "\(unwrappedDistance)km"
//        } else {
//            rightLabel.text = ""
//        }
        
        rightLabel.textColor = .white
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

    }
    
    func presentHalfModal() {
        let halfModalViewController = HalfModalPresentationController()
        halfModalViewController.modalPresentationStyle = .custom
        halfModalViewController.halfModalView.layer.cornerRadius = 40
//        halfModalViewController.transitioningDelegate = self
        
        // MARK: 데이터 바인딩
//        halfModalViewController.data = self.data
        
//        present(halfModalViewController, animated: true, completion: nil)
    }
}


// MARK: - Delegate

extension SearchViewController: SearchViewDelegate {
    
    func locationButtonTapped(_ searchView: SearchView) {
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)

    }
    
    func requestLocationPermissionAuthorization(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func rebrowsingButtonTapped(_ searchView: SearchView) {

    }
    
    
}



