//
//  MyReviewCollectionViewCell.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/09.
//

import UIKit

final class MyReviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MyReviewCollectionViewCell"
    let myReviewCollectionViewCell = MyReviewCollectionViewCell()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
}


// MARK: - Layout

extension MyReviewCollectionViewCell: LayoutProtocol {
    
    func setSubViews() {
        contentView.addSubview(imageView)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

