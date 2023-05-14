//
//  HomeView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    // MARK: - Properties
    
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let recodeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "recodeButton"), for: .normal)
        return button
    }()
    
    private lazy var captionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
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
        backgroundColor = .mainViewGrey
    }
    
    
}


// MARK: - Layouts

extension HomeView: LayoutProtocol {
    
    func setSubViews() {
        [mainImage, recodeButton, captionImage]
            .forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        mainImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(109)
            $0.top.equalTo(self.snp.top).offset(130)
        }
        
        recodeButton.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(364)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainImage.snp.bottom).offset(19.03)
        }
        
        captionImage.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(78)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(recodeButton.snp.bottom).offset(10)
        }
        
    }
}
