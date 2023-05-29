//
//  SearchView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//

import UIKit
import SnapKit

final class SearchView: UIView {
    
    // MARK: - Properties
    let searchBar = UISearchBar()
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureUI()
        setSubViews()
        setLayout()
        configureSearchBar()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        configureSearchBar()
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "시/구까지 입력해주세요."
    }
}


// MARK: - Layouts

extension SearchView: LayoutProtocol {
    
    func setSubViews() {
        [searchBar].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
}
