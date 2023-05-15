//
//  RouteRecordView.swift
//  runnerpia
//
//  Created by Jun on 2023/05/15.
//

import UIKit
import NMapsMap
import CoreLocation

class RouteRecordView: UIView {
    
    // MARK: Properties
    let locationManager = CLLocationManager()
    
    let map: NMFMapView = {
        let map = NMFMapView()
        map.positionMode = .direction
        return map
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureUI()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func configureUI(){
        requestLocationPermissionAuthorization()
    }
    
    func requestLocationPermissionAuthorization(){
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

}

extension RouteRecordView: LayoutProtocol{
    func setSubViews() {
        [map].forEach{ self.addSubview($0) }
    }
    
    func setLayout() {
        map.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}


extension RouteRecordView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locations.first!.coordinate.latitude, lng: locations.first!.coordinate.longitude))
        map.moveCamera(cameraUpdate)
        print(locations)
    }
}
