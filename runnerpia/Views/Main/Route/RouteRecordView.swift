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
        map.mapType = .basic
        map.positionMode = .direction
        return map
    }()
    
    let playSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
        return view
    }()
    
    let playSectionTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "플레이 버튼을 누르면 바로 시작돼요!"
        label.textColor = .black
        return label
    }()
    
    let playButton: UIButton = {
        let btn = UIButton(type:.system)
        
        btn.backgroundColor = hexStringToUIColor(hex: "#0074C9")
        btn.layer.cornerRadius = 45
        btn.clipsToBounds = true
        
        if let playImage = UIImage(systemName: "play.fill")?.withTintColor(.white,renderingMode: .alwaysOriginal){
            
            btn.setImage(playImage, for: .normal)
        }
        return btn
    }()
    
    
    // MARK: - LifeCycles
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
        [map,playSection].forEach{ self.addSubview($0) }
        [playSectionTitle, playButton].forEach{ self.addSubview($0) }
    }
    
    func setLayout() {
        map.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        playSection.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(240)
        }
        
        playSectionTitle.snp.makeConstraints {
            $0.top.equalTo(playSection.snp.top).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        playButton.snp.makeConstraints{
            $0.centerX.equalTo(playSection.snp.centerX)
            $0.centerY.equalTo(playSection.snp.centerY)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
    }
}


extension RouteRecordView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locations.first!.coordinate.latitude, lng: locations.first!.coordinate.longitude))
        map.moveCamera(cameraUpdate)
        
    }
}
