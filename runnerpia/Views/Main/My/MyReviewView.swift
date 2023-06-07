//
//  MyReviewView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//

import UIKit

final class MyReviewView: UIView {
    
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
        backgroundColor = .blue
    }
}


// MARK: - Layouts

extension MyReviewView: LayoutProtocol {
    
    func setSubViews() {

//        [ ]
//            .forEach { self.addSubview($0) }

    }
    
    func setLayout() {
    }
    
}
