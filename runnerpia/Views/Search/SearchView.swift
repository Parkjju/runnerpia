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
}

final class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
    
    // MARK: - Properties
        
    let searchBar = UISearchBar()
    
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


    
    
    // MARK: - Helpers
    
    private func configureUI() {

    }
    
    
}


// MARK: - Layouts

extension SearchView: LayoutProtocol {
    
    func setSubViews() {
        [searchBar, map, locationButton].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        map.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(70)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
}
