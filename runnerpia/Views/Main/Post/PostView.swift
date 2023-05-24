//
//  PostView.swift
//  runnerpia
//
//  Created by Jun on 2023/05/24.
//

import UIKit
import NMapsMap
import CoreLocation

class PostView: UIView {
    // MARK: Properties
    var delegate: PostDataDelegate?
    
    let map: NMFMapView = {
        let map = NMFMapView()
        map.mapType = .basic
        map.positionMode = .direction
        return map
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let timeText = NSMutableAttributedString(string: "12월 31일 저녁, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let text = NSMutableAttributedString(string: "러닝을 완료", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard), NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: "#21A345")])
        
        let remainText = NSMutableAttributedString(string: "했어요!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold, width: .standard)])
        
        
        timeText.append(text)
        timeText.append(remainText)
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.attributedText = timeText
        
        
        return label
    }()
    
    // MARK: 레이블에 지역명 얻어와서 텍스트 업데이트 필요 -> coreLocation API 있음!
    let locationView: UIStackView = {
        let sv = UIStackView()
        
        let firstMarkerImage = UIImageView(image: UIImage(named: "marker")?.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20)))
        let secondMarkerImage = UIImageView(image: UIImage(named: "marker")?.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20)))
        
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
    
    let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = hexStringToUIColor(hex: "#21A345")
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("추천 경로로 등록", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        // MARK: 데이터 전달을 위한 델리게이트 지정
        self.delegate = self.parentViewController!.presentingViewController as! RouteViewController
        
        setSubViews()
        setLayout()
        setUI()
    }
    
    // MARK: Helpers
    // MARK: 데이터 바인딩작업 진행
    func setUI(){
        map.layer.cornerRadius = 10
        
        let (date, startDate, distance, coordinates) = delegate!.getData()
        
        bindingLocation(coordinates)
        bindingTime(date)
    }
    
    func bindingLocation(_ coordinates: [NMGLatLng]){
        let startLocation = CLLocation(latitude: coordinates.first!.lat, longitude: coordinates.first!.lng)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko")
        
        geocoder.reverseGeocodeLocation(startLocation, preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks, let address = placemarks.last else {
                return
            }
            print(address.subLocality) // 중동
//            print(address.locality) - 용인시
//            print(address.name) - 중동 1083
            
        }
    }
    
    func bindingTime(_ date: Date){
        let label = dateView.subviews.last as! UILabel
        
        // MARK: 한국시간으로 변경
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "M월 dd일 E요일 a k시 m분 시작"
        
        // MARK: 날짜 바인딩
        label.text = dateFormatter.string(from: date)
    }

}

extension PostView: LayoutProtocol{
    func setSubViews() {
        [map, dateLabel, locationView, dateView, timeView, distanceView, registerButton].forEach { self.addSubview($0) }
    }
    func setLayout() {
        map.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(self.frame.height / 2)
        }
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(map.snp.leading)
            $0.top.equalTo(map.snp.bottom).offset(10)
        }
        locationView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.lessThanOrEqualTo(self.snp.trailing)
        }
        dateView.snp.makeConstraints {
            $0.leading.equalTo(map.snp.leading)
            $0.top.equalTo(locationView.snp.bottom).offset(10)
            $0.height.equalTo(25)
        }
        timeView.snp.makeConstraints {
            $0.leading.equalTo(map.snp.leading)
            $0.top.equalTo(dateView.snp.bottom)
            $0.height.equalTo(25)
        }
        distanceView.snp.makeConstraints {
            $0.leading.equalTo(map.snp.leading)
            $0.top.equalTo(timeView.snp.bottom)
            $0.height.equalTo(25)
        }
        registerButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        }
    }
}

protocol PostDataDelegate{
    func getData() -> (Date,(TimeInterval,TimeInterval), (Int, Int), [NMGLatLng])
}
