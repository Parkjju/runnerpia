//
//  ReviewMainView.swift
//  runnerpia
//
//  Created by Jun on 2023/06/07.
//

import UIKit
import NMapsMap

class ReviewMainView: UIView {
    
    // MARK: Properties
    var routeData: Route?{
        didSet{
            bindingData()
        }
    }
    let map: NMFMapView = {
        let map = NMFMapView()
        map.positionMode = .disabled
        map.allowsScrolling = false
        map.allowsZooming = false
        return map
    }()

    let completeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let runningTitleText = NSMutableAttributedString(string: "송정뚝방길\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let text = NSMutableAttributedString(string: "러닝을 완료", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard), NSAttributedString.Key.foregroundColor: UIColor.blue400])
        
        let remainText = NSMutableAttributedString(string: "했어요!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard)])
        
        runningTitleText.append(text)
        runningTitleText.append(remainText)
        
        label.attributedText = runningTitleText
        return label
    }()
    
    let locationView: UIStackView = {
        let sv = UIStackView()
        
        let firstMarkerImage = UIImageView(image: UIImage(named: "locationIcon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20)))
        let secondMarkerImage = UIImageView(image: UIImage(named: "locationIcon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20)))
        
        let startLocationLabel = UILabel()
        startLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        startLocationLabel.text = "성동구 송정동"
        
        let rightArrowImage = UIImageView(image: UIImage(systemName: "arrow.right")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        
        let endLocationLabel = UILabel()
        endLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        endLocationLabel.text = "성동구 송정동"
        
        [firstMarkerImage, startLocationLabel, rightArrowImage, secondMarkerImage,endLocationLabel].forEach { sv.addArrangedSubview($0) }
        
        sv.spacing = 8
        sv.distribution = .fillProportionally
        sv.alignment = .fill
        
        return sv
    }()
    
    let dateView: UIView = {
        let view = UIView()
        let calendarImage = UIImageView(image: UIImage(systemName: "calendar")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        
        // MARK: 데이터 전달받고 dateFormatting 후 문자열 추가
        let date = UILabel()
        date.text = "12월 31일 토요일 오후 7시 30분 시작"
        date.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        [calendarImage, date].forEach { view.addSubview($0) }
        
        calendarImage.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(20)
        }
        
        date.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY)
            $0.leading.equalTo(calendarImage.snp.trailing).offset(8)
        }
        
        return view
    }()
    
    let timeView: UIView = {
        let view = UIView()
        let clockImage = UIImageView(image: UIImage(named: "clock")?.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20)))
        
        let timeLabel = UILabel()
        timeLabel.text = "34분 21초"
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        [clockImage, timeLabel].forEach { view.addSubview($0) }
        
        clockImage.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY)
            $0.leading.equalTo(view.snp.leading)
            $0.width.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY)
            $0.leading.equalTo(clockImage.snp.trailing).offset(8)
        }
        
        return view
    }()
    
    let distanceView: UIView = {
        let view = UIView()
        let mapImage = UIImageView(image: UIImage(systemName: "map")?.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20)))
        
        let distanceLabel = UILabel()
        distanceLabel.text = "5.8km"
        distanceLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        [mapImage, distanceLabel].forEach { view.addSubview($0) }
        
        mapImage.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY)
            $0.leading.equalTo(view.snp.leading)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(mapImage.snp.trailing).offset(8)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        return view
    }()
    
    let divider: Divider = {
        let d = Divider()
        return d
    }()
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setSubViews()
        setLayout()
    }
    
    // MARK: Helpers
    func bindingData(){
        guard let routeData = routeData else {
            return
        }
        
        let coordinates: [NMGLatLng] = routeData.arrayOfPos!.map { coordinate in
            NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        }
        
        // MARK: startLocation & endLocation 분리되어 있어야됨
        bindingMap(coordinates)
        bindingStartLocation(routeData.location!)
        bindingEndLocation(routeData.location!)
        bindingTime(routeData.runningDate!)
        bindingElapsedTime(routeData.runningTime!)
        bindingDistance(routeData.distance!)
    }
    
    func bindingMap(_ coordinates: [NMGLatLng]){
        // MARK: 맵 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinates.first!.lat, lng: coordinates.first!.lng))
        map.moveCamera(cameraUpdate)
        
        // MARK: 오버레이
        // 2. 폴리라인 제작
        let pathOverlay = NMFPath()
        pathOverlay.path = NMGLineString(points: coordinates)
        pathOverlay.mapView = map
        pathOverlay.color = .polylineColor
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 10
    }
    
    func bindingStartLocation(_ locationName: String){
        let startLocationLabel = self.locationView.subviews[1] as! UILabel
        startLocationLabel.text = locationName
    }
    
    func bindingEndLocation(_ locationName: String){
        let endLocationLabel = self.locationView.subviews.last as! UILabel
        endLocationLabel.text = locationName
    }
    
    func bindingTime(_ date: String){
        let dateLabel = dateView.subviews.last as! UILabel
        dateLabel.text = date
    }
    
    func bindingElapsedTime(_ elapsedTime: String){
        let label = timeView.subviews[1] as! UILabel
        label.text = elapsedTime
    }
    
    func bindingDistance(_ distance: Double){
        let distanceLabel = distanceView.subviews.last as! UILabel
        distanceLabel.text = "\(distance)km"
    }
}

extension ReviewMainView: LayoutProtocol{
    func setSubViews() {
        [map, completeLabel, locationView , dateView, timeView, distanceView, divider].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        map.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(self.frame.height / 3)
        }
        
        completeLabel.snp.makeConstraints {
            $0.top.equalTo(map.snp.bottom).offset(16)
            $0.leading.equalTo(map.snp.leading)
        }
        
        locationView.snp.makeConstraints {
            $0.top.equalTo(completeLabel.snp.bottom).offset(16)
            $0.leading.greaterThanOrEqualTo(map.snp.leading)
        }
        
        dateView.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom).offset(16)
            $0.leading.equalTo(map.snp.leading)
            $0.height.equalTo(25)
        }
        
        locationView.subviews.first!.snp.makeConstraints {
            $0.centerX.equalTo(dateView.subviews.first!.snp.centerX)
        }
        
        timeView.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(6)
            $0.leading.equalTo(map.snp.leading)
            $0.height.equalTo(25)
        }
        
        distanceView.snp.makeConstraints {
            $0.top.equalTo(timeView.snp.bottom).offset(6)
            $0.leading.equalTo(map.snp.leading)
            $0.height.equalTo(25)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(distanceView.snp.bottom).offset(20)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
        }
    }
}
