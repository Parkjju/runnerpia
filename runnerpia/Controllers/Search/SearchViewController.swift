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

    var pathCoordinates:[NMGLatLng] = []
    let pathOverlay = NMFPath()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        requestLocationPermissionAuthorization()
        configureMap()
    }
    
    override func loadView() {
        view = searchView
    }
    
    
    // MARK: - Selectors
    
    @objc private func cancelButtonButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {

    }
    
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
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(latlng)
    }
    
}


// MARK: - extension Map

extension SearchViewController: CLLocationManagerDelegate, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        print(presented)
        let presented = presented as! HalfModalPresentationController
        presented.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2 / 3, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 1. 카메라 업데이트
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)
        
        pathCoordinates.append(NMGLatLng(lat: locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude))
        
        // 2. 경로 오버레이 표시
        pathOverlay.path = NMGLineString(points: pathCoordinates)
        pathOverlay.color = .blue400
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 10
        pathOverlay.mapView = searchView.map
        
    }
    
    private func configureMap() {
        addMarker()
        addLocationOverlay()
    }

    
    func addMarker() {
        marker.position = NMGLatLng(lat: 37.2785, lng: 127.1440)
        marker.mapView = searchView.map
        
        let viewMarker = createViewMarker()
        marker.iconImage = NMFOverlayImage(image: viewMarker.asImage())

        marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in

            presentHalfModal()
            locationManager.stopUpdatingLocation()
            searchView.map.positionMode = .disabled
            print(overlay)
            overlay.globalZIndex = 10
            return true
        }
    }
    
    func createViewMarker() -> UIImageView {
        
        let particularRouteController = ParticularRouteController()
        let data = particularRouteController.setupData()
        let leftLabelText = "2"
        let rightLabelText = data.distance
        
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
        
        
    }
    
    func presentHalfModal() {
        let halfModalViewController = HalfModalPresentationController()
        halfModalViewController.modalPresentationStyle = .custom
        halfModalViewController.halfModalView.layer.cornerRadius = 40
        halfModalViewController.transitioningDelegate = self
        searchView.map.allowsScrolling = false
        present(halfModalViewController, animated: true, completion: nil)
    }

    
    func addLocationOverlay() {
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
    
    func rebrowsingButtonTapped(_ searchView: SearchView) {
        print("현재 지도에서 재 검색")

    }
    
    
}



