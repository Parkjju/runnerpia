//
//  ParticularCollectionViewCell.swift
//  runnerpia
//Users/jess/Documents/runnerpia/runnerpia/SceneDelegate.swift/
//  Created by juyeong koh on 2023/05/22.
//

import UIKit
import SnapKit

final class ParticularCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let identifier = "ParticularCollectionViewCell"
    let imageView = UIImageView()
    
    let particularRouteController = ParticularRouteController()

    
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

extension ParticularCollectionViewCell: LayoutProtocol {
    
    func setSubViews() {
        addSubview(imageView)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }
    
    
}

