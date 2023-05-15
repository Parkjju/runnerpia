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
            let scaledImage = playImage.scalePreservingAspectRatio(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white, renderingMode: .alwaysOriginal)
            btn.setImage(scaledImage, for: .normal)
        }
        
        btn.addTarget(self, action: #selector(playButtonTouchDownHandler), for: .touchDown)
        btn.addTarget(self, action: #selector(playButtonTouchUpHandler), for:.touchUpInside)
        return btn
    }()
    
    var timer = Timer()
    
    var pushTime: TimeInterval = 0
    
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureUI()
        setSubViews()
        setLayout()
        setupGenerator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    @objc func playButtonTouchDownHandler(){
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addSecondToPushTime), userInfo: nil, repeats: true)
        timer.fire()
        
        UIView.animate(withDuration: 0.3) {
            self.playButton.snp.updateConstraints {
                $0.width.equalTo(120)
                $0.height.equalTo(120)
            }
            self.playButton.layer.cornerRadius = 60
            
            
            self.layoutIfNeeded()
        }
    }
    
    
    // 버튼을 3초보다 덜 누르고 있을때 타이머 초기화 및 뷰 그대로 유지
    @objc func playButtonTouchUpHandler(){
        timer.invalidate()
        pushTime = 0
        
        // 버튼 UI 초기화
        UIView.animate(withDuration: 0.1) {
            self.playButton.snp.updateConstraints {
                $0.width.equalTo(90)
                $0.height.equalTo(90)
            }
            self.playButton.layer.cornerRadius = 45
            
            self.layoutIfNeeded()
        }
        
    }
    
    // 버튼을 3초보다 더 누르고 있는 경우 타이머 초기화 및 뷰 이동
    @objc func addSecondToPushTime(){
        
        pushTime += timer.timeInterval
        
        if(pushTime == 2){
            print("ended")
            self.feedbackGenerator?.notificationOccurred(.success)
        }
        print("hi")
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
    
    func setupGenerator(){
        self.feedbackGenerator = UINotificationFeedbackGenerator()
        self.feedbackGenerator?.prepare()
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
