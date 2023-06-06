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
    let data = Route(user: User(userId: "경준", nickname: "경준"),routeName: "동백 호수공원",distance: 200,arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)], location:"기흥구 언동로" , runningTime: "200분", review: "나무가 풍성한 동백 호수공원을 달려보아요", runningDate: "12월 30일 일요일 오후 2~3시", recommendedTags: ["0","1","2"], secureTags: ["0","1", "2", "3", "4"], files:[UIImage(named: "test1")!, UIImage(named:"test2")!, UIImage(named:"test3")!, UIImage(named:"test4")!])

    let pathOverlay = NMFPath()

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
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
        let presented = presented as! HalfModalPresentationController
        presented.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 2 / 3, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 1. 카메라 업데이트
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)
        
        // MARK: 좌표바인딩 및 데이터 변환
        let nmgCoordinates = data.arrayOfPos!.map { coordinate in
            NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        }
        
        
        // 2. 경로 오버레이 표시
        pathOverlay.path = NMGLineString(points: nmgCoordinates)
        pathOverlay.color = .clear
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 10
        pathOverlay.mapView = searchView.map
        
        let locationOverlay = searchView.map.locationOverlay
        locationOverlay.icon = NMFOverlayImage(name: "myLocation")
        
    }
    
    private func configureMap() {
        addMarker()
    }

    
    func addMarker() {
        marker.position = NMGLatLng(lat: data.arrayOfPos!.first!.latitude, lng: data.arrayOfPos!.first!.longitude)
        marker.mapView = searchView.map
        
        let viewMarker = createViewMarker()
        marker.iconImage = NMFOverlayImage(image: viewMarker.asImage())

        // 마커 터치핸들러
        marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
            presentHalfModal()
            locationManager.stopUpdatingLocation()
            searchView.map.positionMode = .disabled
            overlay.globalZIndex = 10
            pathOverlay.color = .white
            pathOverlay.mapView = searchView.map
            
            return true
        }
    }
    
    func createViewMarker() -> UIImageView {
        
        let particularRouteController = ParticularRouteController()
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
        
        // MARK: 데이터 바인딩
        halfModalViewController.data = self.data
        
        present(halfModalViewController, animated: true, completion: nil)
    }

}


// MARK: - Delegate

extension SearchViewController: SearchViewDelegate {
    
    func locationButtonTapped(_ searchView: SearchView) {
        print("locationButtonTapped !! ")
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        cameraUpdate.animation = .easeIn
        searchView.map.moveCamera(cameraUpdate)

    }
    
    func requestLocationPermissionAuthorization(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func rebrowsingButtonTapped(_ searchView: SearchView) {
        print("현재 지도에서 재 검색")

    }
    
    
}



