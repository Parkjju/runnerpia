//
//  HalfModalView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/02.
//

import UIKit

final class HalfModalView: UIView {
    
    // MARK: - Properties
    
    weak var touchDelegate: UIView? = nil
    
    // -- 0. scrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let view = UIView()
    
        scrollView.clipsToBounds = true
        
        scrollView.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            $0.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            
            $0.leading.equalTo(scrollView.frameLayoutGuide.snp.leading)
            $0.trailing.equalTo(scrollView.frameLayoutGuide.snp.trailing)
            $0.height.equalTo(500)
        }
        return scrollView
    }()
    
    // -- 1. spotLabel

    lazy var spotLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .semiBold24
        return label
    }()
    
    // -- 2. spotStackView
    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "locationIcon")!.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        return imageView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .regular14
        label.text = "성동구 송정동"
        return label
    }()
    
    private lazy var dotIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "dot")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mapIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "mapIcon")!.scalePreservingAspectRatio(targetSize: CGSize(width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .regular14
        return label
    }()
    
    lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationIcon, locationLabel,
                                                       dotIcon,
                                                       mapIcon, distanceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // -- 3. 안심 & 추천태그
    lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .semiBold16
        label.text = "안심 & 추천태그"
        return label
    }()
    
    // -- 4. tagsCollectionView
    let tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        
        collectionView.collectionViewLayout = layout
        
        return collectionView
    }()
    
    
    // MARK: - LifeCycles
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard let view = super.hitTest(point, with: event) else {
            return nil
        }
        guard view == self, let point = touchDelegate?.convert(point, from: self) else {
            return view
        }
        return touchDelegate?.hitTest(point, with: event)
    }
    
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

extension HalfModalView: LayoutProtocol {
    
    func setSubViews() {
        
        self.addSubview(scrollView)
        
        [spotLabel, locationStackView, tagsLabel, tagsCollectionView ]
            .forEach { scrollView.subviews.first!.addSubview($0) }

    }
    
    func setLayout() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        spotLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.subviews.first!.snp.top).offset(20)
            $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading).offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing).offset(-Constraints.paddingLeftAndRight)
        }
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(spotLabel.snp.bottom).offset(10)
            $0.leading.equalTo(spotLabel.snp.leading)
        }
        
        tagsLabel.snp.makeConstraints {
            $0.top.equalTo(locationStackView.snp.bottom).offset(16)
            $0.leading.equalTo(locationStackView.snp.leading)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.leading.equalTo(tagsLabel.snp.leading)
            $0.trailing.lessThanOrEqualTo(self.scrollView.snp.trailing).offset(-16)
            $0.top.equalTo(tagsLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(self.scrollView.snp.bottom).offset(-16)
            $0.height.greaterThanOrEqualTo(80)
        }
        
    }
    
}
