//
//  MyPageView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/06.
//

import UIKit

final class MyPageView: UIView {
    
    // MARK: - Properties
    
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
        backgroundColor = .grey100
    }
}


// MARK: - Layouts

extension MyPageView: LayoutProtocol {
    
    func setSubViews() {


    }
    
    func setLayout() {
    }
    
}
