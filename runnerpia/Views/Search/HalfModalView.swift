//
//  HalfModalView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/02.
//

import UIKit

final class HalfModalView: UIView {
    
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
        backgroundColor = .blue400
    }
}


// MARK: - Layouts

extension HalfModalView: LayoutProtocol {
    
    func setSubViews() {


    }
    
    func setLayout() {
    }
    
}
