//
//  ParticularView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/22.
//

import UIKit
import NMapsMap
import CoreLocation

final class ParticularView: UIView {
    
    // MARK: - Properties
    
    private lazy var map: NMFMapView = {
        let map = NMFMapView()
        map.mapType = .basic
        map.positionMode = .direction
        map.layer.cornerRadius = 20
        return map
    }()
    
    
    // -- 1. spotStackView
    private lazy var spotLabel: UILabel = {
        let label = UILabel()
        label.text = "송정 뚝방길"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var bookmarkIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "bookmarkIcon")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var spotStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spotLabel, bookmarkIcon])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // -- 2. locationStackView
    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "locationIcon")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "성동구 송정동"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var dotIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "dot")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mapIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "mapIcon")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "5.8km"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationIcon, locationLabel,
                                                       dotIcon,
                                                       mapIcon, distanceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    // -- 3 textView
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "성동구에서 가장 안전한 러닝 루트를 소개합니다! 나무가 많아 그늘 아래에서 달릴 수 있고, 관리도 참 잘 되어서 쾌적해요. 무엇보다도 해질 때 쯤 강 너머로 보이는 석양을 보면서 달리면 가슴이 벅차오릅니다... 오후 10시 이후로는 한산한 편이지만 가로등이 다 켜져있어서 안전해요~!"
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textView
    }()
    
    // -- 4 Tags
    
    // -- 5 경로 버튼
    lazy var routeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("경로 따라가기", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .mainBlue
        return button
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
    
    
    // MARK: - Helpers
    private func configureUI() {
        
    }
}


// MARK: - Layouts

extension ParticularView: LayoutProtocol {
    
    func setSubViews() {
        
        [map, spotStackView, locationStackView, textView, routeButton]
            .forEach { self.addSubview($0) }
  
    }
    
    func setLayout() {
        
        map.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(263)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        spotStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(map.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        locationStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(spotStackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-158)
        }
        
        textView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(locationStackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        routeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(52)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(6)
        }
        
    }
    
}
