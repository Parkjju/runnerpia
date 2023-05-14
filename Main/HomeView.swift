//
//  HomeView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit

class HomeView: UIView {
    
    // MARK: - Properties
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureUI()
//        setSubViews()
//        setLayout()
//
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = .mainBlue
    }
}


// MARK: - Layouts

extension HomeView: LayoutProtocol {
    
    func setSubViews() {
    }
    
    func setLayout() {
    }
    
}
