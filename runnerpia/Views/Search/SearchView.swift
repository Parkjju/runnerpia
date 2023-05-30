//
//  SearchView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//

import UIKit
import SnapKit
import NMapsMap

final class SearchView: UIView {
    
    // MARK: - Properties
        
    let searchBar = UISearchBar()
    
    lazy var map: NMFMapView = {
        let map = NMFMapView()
        map.mapType = .basic
        map.positionMode = .direction
        return map
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

extension SearchView: LayoutProtocol {
    
    func setSubViews() {
        [searchBar, map].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        map.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
