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
    var delegate: ReviewDataDelegate?
    
    var routeData: Route?{
        didSet{
            bindingData()
        }
    }
    
    // MARK: 경로 생성시 RouteView로부터 새롭게 생성되어 바인딩되는 데이터
    var runningData: (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng])?{
        didSet{
            bindingData()
        }
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        let view = UIView()
        
        sv.clipsToBounds = true
        
        sv.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalTo(sv.contentLayoutGuide.snp.top)
            $0.leading.equalTo(sv.contentLayoutGuide.snp.leading)
            $0.trailing.equalTo(sv.contentLayoutGuide.snp.trailing)
            $0.bottom.equalTo(sv.contentLayoutGuide.snp.bottom)
            
            $0.leading.equalTo(sv.frameLayoutGuide.snp.leading)
            $0.trailing.equalTo(sv.frameLayoutGuide.snp.trailing)
            $0.height.equalTo(sv.frameLayoutGuide.snp.height).priority(.low)
        }
        return sv
    }()
    
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
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "다녀오신 경로를 평가해주세요!"
        label.font = .semiBold18
        return label
    }()
    
    let secureTagSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "안심태그"
        label.font = .medium16
        return label
    }()
    
    let secureTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        cv.tag = 1
        
        return cv
    }()
    
    let normalTagSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "일반태그"
        label.font = UIFont.medium16
        label.textColor = .grey800
        return label
    }()
    
    let normalTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        cv.tag = 2
        
        return cv
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
        
        // MARK: 러닝현황 정보 불러오기
        setupController()
    }
    
    // MARK: Helpers
    func setupController(){
        delegate = self.parentViewController as! ReviewMainViewController
        self.runningData = delegate?.getData()
        
        secureTagCollectionView.delegate = self.parentViewController as! ReviewMainViewController
    }
    
    func bindingData(){
        guard let routeData = routeData, let runningData = runningData else {
            return
        }
        
        let (date, elapsedTime, distance, coordinates) = runningData
        
        // MARK: startLocation & endLocation 분리되어 있어야됨
        bindingMap(coordinates)
        bindingStartLocation(coordinates)
        bindingEndLocation(coordinates)
        bindingTime(date)
        bindingElapsedTime(elapsedTime)
        bindingDistance(distance)
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
    func bindingStartLocation(_ coordinates: [NMGLatLng]){
        let startLocation = CLLocation(latitude: coordinates.first!.lat, longitude: coordinates.first!.lng)
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko")
        
        geocoder.reverseGeocodeLocation(startLocation, preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks, let address = placemarks.last else {
                return
            }
            // MARK: address.locality - 군/구
            // MARK: address.subLocality - 동
            
            let startLocationLabel = self.locationView.subviews[1] as! UILabel
            
            DispatchQueue.main.async {
                startLocationLabel.text = "\(address.locality!) \(address.subLocality!)"
            }
        }
    }
    func bindingEndLocation(_ coordinates: [NMGLatLng]){
        let endLocation = CLLocation(latitude: coordinates.last!.lat, longitude: coordinates.last!.lng)
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko")
        
        geocoder.reverseGeocodeLocation(endLocation, preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks, let address = placemarks.last else {
                return
            }
            // MARK: address.locality - 군/구
            // MARK: address.subLocality - 동
            
            let endLocationLabel = self.locationView.subviews.last as! UILabel
            
            DispatchQueue.main.async {
                endLocationLabel.text = "\(address.locality!) \(address.subLocality!)"
            }
        }
    }
    func bindingTime(_ date: Date){
        let label = dateView.subviews.last as! UILabel
        
        // MARK: 한국시간으로 변경
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "M월 dd일 E요일 a h시 m분 시작"
        
        // MARK: 러닝 완료 레이블
        let completeDateFormatter = DateFormatter()
        completeDateFormatter.locale = Locale(identifier: "ko")
        completeDateFormatter.dateFormat = "M월 d일, \n"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let timeText = NSMutableAttributedString(string: completeDateFormatter.string(from: date), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let text = NSMutableAttributedString(string: "러닝을 완료", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard), NSAttributedString.Key.foregroundColor: UIColor.blue400])
        
        let remainText = NSMutableAttributedString(string: "했어요!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard)])
        
        
        timeText.append(text)
        timeText.append(remainText)
        let dateLabel = dateView.subviews.last as! UILabel
        dateLabel.attributedText = timeText
        
        // MARK: 날짜 바인딩
        label.text = dateFormatter.string(from: date)
    }
    func bindingElapsedTime(_ elapsedTime: (TimeInterval, TimeInterval)){
        let (elapsedMinute, elapsedSecond) = elapsedTime
        
        let label = timeView.subviews[1] as! UILabel
        label.text = elapsedMinute > 0 ? "\(Int(elapsedMinute))분 \(Int(elapsedSecond))초" : "\(Int(elapsedSecond))초"
    }
    func bindingDistance(_ distance: (Int, Int)){
        let (km, meter) = distance
        let distanceLabel = distanceView.subviews.last as! UILabel
        distanceLabel.text = meter / 10 > 0 ? "\(km).\(meter)km" : "\(km).0\(meter)km"
    }
}

extension ReviewMainView: LayoutProtocol{
    func setSubViews() {
        self.addSubview(scrollView)
        [map, completeLabel, locationView , dateView, timeView, distanceView, divider, rateLabel, secureTagSectionLabel].forEach { scrollView.subviews.first!.addSubview($0) }
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
        
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20)
            $0.leading.equalTo(map.snp.leading)
        }
        
        secureTagSectionLabel.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(rateLabel.snp.leading)
        }
        
        secureTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(secureTagSectionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(secureTagSectionLabel.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
            $0.height.equalTo(60)
        }
    }
}

protocol ReviewDataDelegate{
    func getData() -> (Date,(TimeInterval,TimeInterval), (Int, Int), [NMGLatLng])
}
