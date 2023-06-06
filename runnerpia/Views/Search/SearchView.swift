//
//  SearchView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

protocol SearchViewDelegate: AnyObject {
    func locationButtonTapped(_ searchView: SearchView)
    func rebrowsingButtonTapped(_ searchView: SearchView)
}

final class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
    
    // MARK: - Properties
        
    lazy var map: NMFMapView = {
        let map = NMFMapView()
        map.mapType = .basic
        map.positionMode = .direction
        return map
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "locationButton"), for: .normal)
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rebrowsingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue400
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        let iconImage = UIImage(named: "rebrowsingButton")
        button.setImage(iconImage, for: .normal)
        button.setTitle("현재 지도에서 재 검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .semiBold14
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(rebrowsingButtonTapped), for: .touchUpInside)
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
    
    // MARK: - Selectors
    
    @objc private func locationButtonTapped() {
        delegate?.locationButtonTapped(self)
    }
    
    @objc private func rebrowsingButtonTapped() {
        delegate?.rebrowsingButtonTapped(self)
    }


    
    
    // MARK: - Helpers
    
    private func configureUI() {

    }
    
    
}


// MARK: - Layouts

extension SearchView: LayoutProtocol {
    
    func setSubViews() {
        [ map, locationButton, rebrowsingButton ].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        
        map.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        rebrowsingButton.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(14)
            $0.trailing.equalTo(locationButton)
            $0.height.equalTo(36)
            $0.width.equalTo(177)
        }
    }
    
}
