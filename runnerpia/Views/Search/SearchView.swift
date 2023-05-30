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
        
    private lazy var map: NMFMapView = {
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
        addSubview(map)
    }
    
    func setLayout() {
        map.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
