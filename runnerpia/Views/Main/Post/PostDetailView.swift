//
//  PostDetailView.swift
//  runnerpia
//
//  Created by 박경준 on 2023/05/25.
//

import UIKit
import NMapsMap

class PostDetailView: UIView {
    // MARK: properties
    
    var bindingData: (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng])?{
        didSet{
            updateUI()
        }
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        let view = UIView()
        
        sv.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalTo(sv.contentLayoutGuide.snp.top)
            $0.leading.equalTo(sv.contentLayoutGuide.snp.leading)
            $0.trailing.equalTo(sv.contentLayoutGuide.snp.trailing)
            $0.bottom.equalTo(sv.contentLayoutGuide.snp.bottom)
            
            $0.leading.equalTo(sv.frameLayoutGuide.snp.leading)
            $0.trailing.equalTo(sv.frameLayoutGuide.snp.trailing)
            $0.height.equalTo(1200)
        }
        return sv
    }()
    
    let map: NMFMapView = {
        let map = NMFMapView()
        map.allowsScrolling = false
        map.layer.cornerRadius = 10
        return map
    }()
    
    let pathSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝 경로 이름"
        label.font = UIFont.semiBold18
        return label
    }()
    
    let pathNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.grey300.cgColor
        tf.layer.borderWidth = 1
        tf.font = UIFont.semiBold18
        tf.placeholder = "송정뚝방길"
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.setLeftPaddingPoints(4)
        tf.setRightPaddingPoints(4)
        
        // 클리어버튼 아이콘 커스텀 가능 여부 서치
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let pathInformationSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "경로 정보"
        label.font = UIFont.semiBold18
        return label
    }()
    
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
    
    let divider: Divider = {
        let d = Divider()
        return d
    }()
    
    let rateSectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBold18
        label.text = "다녀오신 경로를 평가해주세요!"
        return label
    }()
    
    let secureTagSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "안심태그"
        label.font = UIFont.medium16
        label.textColor = .grey800
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
    
    let dividerAfterTag: UIView = {
        let d = Divider()
        return d
    }()
    
    
    // MARK: LifeCycles
    override func didMoveToSuperview() {
        setSubViews()
        setLayout()
        setupController()
        updateCollectionViewHeight()
    }
    
    // MARK: Helpers
    func updateUI(){
        guard let bindingData = bindingData else {return}
        
        // 1. 카메라 이동
        map.moveCamera(NMFCameraUpdate(scrollTo: bindingData.3.first!))
        
        // 2. 폴리라인 제작
        let pathOverlay = NMFPath()
        pathOverlay.path = NMGLineString(points: bindingData.3)
        pathOverlay.mapView = map
        pathOverlay.color = .polylineColor
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 10
    }
    
    func setupController(){
        secureTagCollectionView.delegate = self.parentViewController as! PostDetailViewController
        secureTagCollectionView.dataSource = self.parentViewController as! PostDetailViewController
        
        normalTagCollectionView.delegate = self.parentViewController as! PostDetailViewController
        normalTagCollectionView.dataSource = self.parentViewController as! PostDetailViewController
    }
    
    func updateCollectionViewHeight(){
        // 안심태그 컬렉션뷰 dynamic height
        secureTagCollectionView.setNeedsLayout()
        secureTagCollectionView.layoutIfNeeded()
        
        if(secureTagCollectionView.contentSize.height > secureTagCollectionView.frame.height){
            secureTagCollectionView.snp.updateConstraints {
                $0.height.equalTo(secureTagCollectionView.contentSize.height)
            }
        }
        
        normalTagCollectionView.setNeedsLayout()
        normalTagCollectionView.layoutIfNeeded()
        
        if(normalTagCollectionView.contentSize.height > normalTagCollectionView.frame.height){
            normalTagCollectionView.snp.updateConstraints {
                $0.height.equalTo(normalTagCollectionView.contentSize.height)
            }
        }
    }
}

extension PostDetailView: LayoutProtocol{
    func setSubViews() {
        self.addSubview(scrollView)
        [map, pathSectionLabel, pathNameTextField, pathInformationSectionLabel, locationView, dateView, timeView, distanceView, divider, rateSectionLabel, secureTagSectionLabel, secureTagCollectionView, normalTagSectionLabel, normalTagCollectionView, dividerAfterTag].forEach { scrollView.subviews.first!.addSubview($0) }
    }
    func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        map.snp.makeConstraints {
            $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading).offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing).offset(-Constraints.paddingLeftAndRight)
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            $0.height.equalTo(self.frame.height / 4)
        }
        
        pathSectionLabel.snp.makeConstraints {
            $0.top.equalTo(map.snp.bottom).offset(20)
            $0.leading.equalTo(map.snp.leading)
        }
        
        pathNameTextField.snp.makeConstraints {
            $0.top.equalTo(pathSectionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
            $0.height.equalTo(40)
        }
        
        pathInformationSectionLabel.snp.makeConstraints {
            $0.top.equalTo(pathNameTextField.snp.bottom).offset(20)
            $0.leading.equalTo(map.snp.leading)
        }
        
        locationView.snp.makeConstraints {
            $0.top.equalTo(pathInformationSectionLabel.snp.bottom).offset(10)
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
        
        rateSectionLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20)
            $0.leading.equalTo(map.snp.leading)
        }
        
        secureTagSectionLabel.snp.makeConstraints {
            $0.top.equalTo(rateSectionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(map.snp.leading)
        }
        
        secureTagCollectionView.snp.makeConstraints {
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
            $0.top.equalTo(secureTagSectionLabel.snp.bottom).offset(10)
            
            // 다이나믹 height 오토레이아웃 지정 가능?
            $0.height.equalTo(60)
        }
        
        normalTagSectionLabel.snp.makeConstraints {
            $0.top.equalTo(secureTagCollectionView.snp.bottom)
            $0.leading.equalTo(map.snp.leading)
        }
        
        normalTagCollectionView.snp.makeConstraints {
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
            $0.top.equalTo(normalTagSectionLabel.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        
        dividerAfterTag.snp.makeConstraints {
            $0.top.equalTo(normalTagCollectionView.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
        }
    }
}
