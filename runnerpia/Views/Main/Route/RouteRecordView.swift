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
    var changeViewDelegate: ChangeViewDelegate?
    let locationManager = CLLocationManager()
    let pathOverlay = NMFPath()
    
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
    
    let elapsedTimeSection: UIStackView = {
        let sv = UIStackView()
        
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        
        let elapsedTimeLabel = UILabel()
        elapsedTimeLabel.text = "00:00"
        elapsedTimeLabel.font = UIFont.boldSystemFont(ofSize: 34)
        elapsedTimeLabel.textColor = .black
        elapsedTimeLabel.textAlignment = .center
        
        let elapsedTimeTitle = UILabel()
        elapsedTimeTitle.text = "시간"
        elapsedTimeTitle.font = UIFont.boldSystemFont(ofSize: 18)
        elapsedTimeTitle.textColor = .black
        elapsedTimeTitle.textAlignment = .center
        
        [elapsedTimeLabel, elapsedTimeTitle].forEach{ sv.addSubview($0) }
        
        elapsedTimeLabel.snp.makeConstraints {
            $0.centerX.equalTo(sv.snp.centerX)
        }
        
        elapsedTimeTitle.snp.makeConstraints {
            $0.centerX.equalTo(sv.snp.centerX)
            $0.top.equalTo(elapsedTimeLabel.snp.bottom).offset(5)
        }
        
        return sv
    }()
    
    let movedDistanceSection: UIStackView = {
        let sv = UIStackView()
        
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        
        let movedDistanceLabel = UILabel()
        movedDistanceLabel.text = "0.00km"
        movedDistanceLabel.font = UIFont.boldSystemFont(ofSize: 34)
        movedDistanceLabel.textColor = .black
        movedDistanceLabel.textAlignment = .center
        
        let movedDistanceTitle = UILabel()
        movedDistanceTitle.text = "거리"
        movedDistanceTitle.font = UIFont.boldSystemFont(ofSize: 18)
        movedDistanceTitle.textColor = .black
        movedDistanceTitle.textAlignment = .center
        
        [movedDistanceLabel, movedDistanceTitle].forEach{ sv.addSubview($0) }
        
        movedDistanceLabel.snp.makeConstraints {
            $0.centerX.equalTo(sv.snp.centerX)
        }
        
        movedDistanceTitle.snp.makeConstraints {
            $0.centerX.equalTo(sv.snp.centerX)
            $0.top.equalTo(movedDistanceLabel.snp.bottom).offset(5)
        }
        
        return sv
    }()
    
    let playButtonDuringRecord: UIButton = {
        let btn = UIButton(type:.system)
        
        btn.backgroundColor = hexStringToUIColor(hex: "#21A345")
        btn.layer.cornerRadius = 45
        btn.clipsToBounds = true
        
        if let playImage = UIImage(systemName: "play.fill")?.withTintColor(.white,renderingMode: .alwaysOriginal){
            let scaledImage = playImage.scalePreservingAspectRatio(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white, renderingMode: .alwaysOriginal)
            btn.setImage(scaledImage, for: .normal)
        }
        
        btn.addTarget(self, action: #selector(playButtonDuringRecordTouchUpHandler), for:.touchUpInside)
        return btn
    }()
    
    let stopButton: UIButton = {
        let btn = UIButton(type:.system)
        
        btn.backgroundColor = hexStringToUIColor(hex: "#FF645A")
        btn.layer.cornerRadius = 45
        btn.clipsToBounds = true
        
        if let playImage = UIImage(systemName: "stop.fill")?.withTintColor(.white,renderingMode: .alwaysOriginal){
            let scaledImage = playImage.scalePreservingAspectRatio(targetSize: CGSize(width: 35, height: 35)).withTintColor(.white, renderingMode: .alwaysOriginal)
            btn.setImage(scaledImage, for: .normal)
        }
        
        return btn
    }()
    
    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "정지 버튼을 길게 누르면 \n러닝이 종료됩니다."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        let closeButton = UIButton(type:.system)
        closeButton.setBackgroundImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal).scalePreservingAspectRatio(targetSize: CGSize(width:14,height:14)), for: .normal)
        closeButton.backgroundColor = .clear
        
        [label, closeButton].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(20)
            $0.right.equalTo(view.snp.right).offset(-20)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.top)
            $0.right.equalTo(view.snp.right).offset(-20)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }
        
        closeButton.addTarget(self, action: #selector(alertViewCloseButtonTapped), for: .touchUpInside)
        
        view.layer.cornerRadius = 10
        view.isHidden = true
        view.layer.opacity = 0
        
        return view
    }()
    
    var timer = Timer()
    
    var pushTime: TimeInterval = 0
    
    // MARK: 전달 필요한 데이터 1. elapsedSeconds / elapsedMinutes
    var elapsedSeconds: TimeInterval = 0
    var elapsedMinutes: TimeInterval = 0
    
    // MARK: 전달 필요한 데이터 2. 오늘 날짜 및 시간
    var today = Date()
    
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    var isRecordPaused: Bool?
    var isRecordStarted: Bool = false
    
    var previousLocation: CLLocation?
    
    // MARK: 전달 필요한 데이터 3. 누적 거리
    var accumulatedDistance = 0
    var accumulatedMeter = 0
    var accumulatedKilometer = 0
    
    // MARK: 전달 필요한 데이터 4. 누적 좌표값들
    var pathCoordinates:[NMGLatLng] = []
    
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
    
    override func didMoveToSuperview() {
        self.changeViewDelegate = self.parentViewController as! RouteViewController
    }
    
    // MARK: Selectors
    @objc func playButtonTouchDownHandler(){
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addSecondToPushTime), userInfo: nil, repeats: true)
        timer.fire()
        
        animateButton(isReset: false)
    }
    
    
    // 버튼을 3초보다 덜 누르고 있을때 타이머 초기화 및 뷰 그대로 유지
    @objc func playButtonTouchUpHandler(){
        timer.invalidate()
        pushTime = 0
        
        let alertViewLabel = alertView.subviews.first as! UILabel
        alertViewLabel.text = isRecordStarted ? "종료버튼을 길게 누르면\n러닝 기록이 종료됩니다." : "시작버튼을 길게 누르면\n러닝 기록이 시작됩니다."
        
        UIView.animate(withDuration: 0.2) {
            self.alertView.isHidden = false
            self.alertView.layer.opacity = 1
        }
        
        // 버튼 UI 초기화
        animateButton(isReset: true)
    }
    
    // 버튼을 3초보다 더 누르고 있는 경우 타이머 초기화 및 뷰 이동
    @objc func addSecondToPushTime(){
        pushTime += timer.timeInterval
        
        if(pushTime == 2 && !isRecordStarted){
            
            // 시작시간 초기화
            today = Date()
            
            self.feedbackGenerator?.notificationOccurred(.success)
            playButton.removeTarget(nil, action: nil, for: .allEvents)
            setupRecordingUI()
            
            isRecordStarted = true
            pushTime = 0
            
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedLabels), userInfo: nil, repeats: true)
        }else if(pushTime == 2 && isRecordStarted){
            self.feedbackGenerator?.notificationOccurred(.success)
            
            // 위치업데이트 중단
            locationManager.stopUpdatingLocation()
            if(pathCoordinates.count == 0){
                self.parentViewController?.dismiss(animated: true)
            }
            
            changeViewDelegate?.nextView()
        }
    }
    
    // 레코드 이후 두개로 쪼개진 재생 - 멈춤버튼 중 재생버튼에 해당되는 부분
    @objc func playButtonDuringRecordTouchUpHandler(){
        isRecordPaused = false
        
        playButtonDuringRecord.isHidden = true
        stopButton.isHidden = true
        
        playButton.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedLabels), userInfo: nil, repeats: true)
    }
    
    // 기존 플레이버튼이 레코드 상태에 따라 다른 역할을 하게되었을때 호출되는 셀렉터 함수
    @objc func playButtonTouchUpHandlerDuringRecord(){
        guard let isPaused = self.isRecordPaused else {
            self.isRecordPaused = false
            return
        }
        
        self.isRecordPaused = !isPaused
        
        if(self.isRecordPaused!){
            self.playButton.isHidden = true
            
            self.playButtonDuringRecord.isHidden = false
            self.stopButton.isHidden = false
            
            timer.invalidate()
        }else{
            self.playButton.isHidden = false
            
            self.playButtonDuringRecord.isHidden = true
            self.stopButton.isHidden = true
        }
    }
    
    @objc func stopButtonTouchDownHandler(){
        timer.invalidate()
        
        pushTime = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addSecondToPushTime), userInfo: nil, repeats: true)
        timer.fire()
        
        animateButton(isReset: false)
    }
    
    // 누적 시간 및 이동거리 계산 셀렉터 함수 - 내부에서 레이블 업데이트 로직과 거리 업데이트 로직이 함께 실행됨
    @objc func updateElapsedLabels(){
        // MARK: 시간 레이블 업데이트
        let elapsedTimeLabel = elapsedTimeSection.subviews.first as! UILabel
        elapsedSeconds += 1
        
        if(elapsedSeconds >= 60){
            elapsedMinutes += 1
            elapsedSeconds = 0
        }
        
        let minuteString = Int(elapsedMinutes / 10) == 0 ? "0\(Int(elapsedMinutes))" : "\(Int(elapsedMinutes))"
        let secondString = Int(elapsedSeconds / 10) == 0 ? "0\(Int(elapsedSeconds))" : "\(Int(elapsedSeconds))"
        
        elapsedTimeLabel.text = "\(minuteString):\(secondString)"
    }
    
    @objc func alertViewCloseButtonTapped(){
        alertView.isHidden = true
        alertView.layer.opacity = 0
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
    
    // 버튼 2초 유지 후 교체되는 UI설정
    func setupRecordingUI(){
        animateButton(isReset: true)
        
        playButton.backgroundColor = hexStringToUIColor(hex: "#737373")
        
        playSectionTitle.isHidden = true
        
        if let pauseImage = UIImage(systemName: "pause.fill") {
            let scaledImage = pauseImage.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 34)).withTintColor(.white, renderingMode: .alwaysOriginal)
            playButton.setImage(scaledImage, for: .normal)
        }
        
        setLayoutAfterRecord()
        updateLayoutAfterRecord()
        
        setRecordButtonPausedSelector()
    }
    
    // 경로 기록 시작 후 섹션UI 레이아웃 업데이트
    func setLayoutAfterRecord(){
        [elapsedTimeSection, movedDistanceSection].forEach{ playSection.addSubview($0) }
    }
    
    func updateLayoutAfterRecord(){
        elapsedTimeSection.snp.makeConstraints {
            $0.top.equalTo(playSection.snp.top).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(playSection.snp.centerX).offset(0)
            $0.height.equalTo(100)
        }
        
        movedDistanceSection.snp.makeConstraints {
            $0.top.equalTo(playSection.snp.top).offset(30)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(playSection.snp.centerX).offset(0)
            $0.height.equalTo(100)
        }
        
        playButtonDuringRecord.snp.makeConstraints{
            $0.centerX.equalTo(elapsedTimeSection.snp.centerX)
            $0.centerY.equalTo(playSection.snp.centerY).offset(30)
            $0.height.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        stopButton.snp.makeConstraints {
            $0.centerX.equalTo(movedDistanceSection.snp.centerX)
            $0.centerY.equalTo(playSection.snp.centerY).offset(30)
            $0.height.height.equalTo(90)
            $0.width.equalTo(90)
        }
    }
    
    // 버튼 애니메이션 함수화
    // isReset true: 버튼 너비 높이 90고정 / false: 버튼 너비 높이 120
    // 레코딩 시작된 이후에는 playButton이 아닌 stopButton 레이아웃을 조정해야함.
    func animateButton(isReset: Bool){
        let animateTarget = isRecordStarted ? stopButton : playButton
        
        if(isReset){
            UIView.animate(withDuration: 0.1) {
                animateTarget.snp.updateConstraints {
                    $0.width.equalTo(90)
                    $0.height.equalTo(90)
                }
                animateTarget.layer.cornerRadius = 45
                self.layoutIfNeeded()
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                animateTarget.snp.updateConstraints {
                    $0.width.equalTo(self.isRecordStarted ? 100 : 120)
                    $0.height.equalTo(self.isRecordStarted ? 100 : 120)
                }
                animateTarget.layer.cornerRadius = self.isRecordStarted ? 50 : 60
                
                self.layoutIfNeeded()
            }
        }
    }
    
    // 버튼 일시정지 이벤트 함수 - touchUpInside 동일 이벤트에 대해 서로 다른 셀렉터 등록을 위한 함수
    func setRecordButtonPausedSelector(){
        playButton.addTarget(self, action: #selector(playButtonTouchUpHandlerDuringRecord), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTouchDownHandler), for:.touchDown)
        stopButton.addTarget(self, action: #selector(playButtonTouchUpHandler), for:.touchUpInside)
    }
}

extension RouteRecordView: LayoutProtocol{
    func setSubViews() {
        [map,playSection, alertView].forEach{ self.addSubview($0) }
        [playSectionTitle, playButton, playButtonDuringRecord, stopButton].forEach{ self.addSubview($0) }
        
        playButtonDuringRecord.isHidden = true
        stopButton.isHidden = true
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
        
        alertView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(60)
        }
        
        playSectionTitle.snp.makeConstraints {
            $0.top.equalTo(playSection.snp.top).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        playButton.snp.makeConstraints{
            $0.centerX.equalTo(playSection.snp.centerX)
            $0.centerY.equalTo(playSection.snp.centerY).offset(30)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
    }
}

// MARK: 백그라운드 로케이션 트래킹 관련 - always tracking으로 체크되어 있는지 확인 및 예외처리
extension RouteRecordView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locations.first!.coordinate.latitude, lng: locations.first!.coordinate.longitude))
        map.moveCamera(cameraUpdate)
        
        guard let isRecordPaused else {
            return
        }
        
        // 사용자가 멈춰있는데 좌표값에 변화가 있는게 감지가 된 경우 - 경로 트래킹 재시작
        if(isRecordPaused){
            // 셀렉터 호출시 자동으로 paused값은 변화함
            // MARK: 20미터 이상 진행 후에 재시작
            // 음성 재생같은 피드백 필요
            guard let previousLocation else {return}
            if(locationManager.location!.distance(from: previousLocation) > 20){
                self.perform(#selector(playButtonDuringRecordTouchUpHandler))
            }else{
                return
            }
            
        }else{
            // MARK: 거리 레이블 업데이트
            let elapsedDistanceLabel = movedDistanceSection.subviews.first as! UILabel
            guard let previous = previousLocation else {
                previousLocation = locationManager.location
                return
            }
            accumulatedDistance += Int(locationManager.location!.distance(from: previous))
            
            if(accumulatedDistance / 10 >= 1){
                accumulatedMeter += 1
                accumulatedDistance = accumulatedDistance % 10
            }
            if(accumulatedMeter / 100 >= 1){
                accumulatedKilometer += 1
                accumulatedMeter = 0
            }
            
            let meterString = Int(accumulatedMeter / 10) == 0 ? "0\(accumulatedMeter)" : "\(accumulatedMeter)"
            let kilometerString = "\(accumulatedKilometer)"
            
            elapsedDistanceLabel.text = "\(kilometerString).\(meterString)km"
            
            previousLocation = locationManager.location
            pathCoordinates.append(NMGLatLng(lat: locationManager.location!.coordinate.latitude, lng: locationManager.location!.coordinate.longitude))
            
            pathOverlay.path = NMGLineString(points: pathCoordinates)
            pathOverlay.color = hexStringToUIColor(hex: "#21A345")
            pathOverlay.outlineColor = .clear
            pathOverlay.width = 10
            pathOverlay.mapView = map
        }
    }
}

protocol ChangeViewDelegate: AnyObject{
    func nextView()
}
