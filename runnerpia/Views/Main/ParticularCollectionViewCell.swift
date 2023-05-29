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
    let particularRouteController = ParticularRouteController()

    lazy var imageView: UIImageView = UIImageView()

    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
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

extension ParticularCollectionViewCell: LayoutProtocol {
    
    func setSubViews() {
        [imageView, numberLabel].forEach { self.addSubview($0) }
        }
    
    
    func setLayout() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        numberLabel.snp.makeConstraints {
            $0.centerX.equalTo(imageView)
            $0.centerY.equalTo(imageView)
        }
    }
    
    
}

