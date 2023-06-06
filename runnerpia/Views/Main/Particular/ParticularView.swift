//
//  ParticularView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/22.
//

import UIKit
import NMapsMap
import CoreLocation

protocol ParticularViewDelegate: AnyObject {
    func bookmarkButtonTapped(_ particularView: ParticularView)
    func routeButtonTapped(_ particularView: ParticularView)

}

final class ParticularView: UIView {
    
    weak var delegate: ParticularViewDelegate?
    
    // MARK: - Properties
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        let view = UIView()
        
        sv.clipsToBounds = true
        
        sv.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalTo(sv.contentLayoutGuide.snp.top)
            $0.leading.equalTo(sv.contentLayoutGuide.snp.leading)
            $0.trailing.equalTo(sv.contentLayoutGuide.snp.trailing)
            $0.bottom.equalTo(sv.contentLayoutGuide.snp.bottom)
            
            $0.width.equalTo(sv.frameLayoutGuide.snp.width)
            $0.height.equalTo(sv.frameLayoutGuide.snp.height).priority(.low)
        }
        return sv
    }()
    
    lazy var map: NMFMapView = {
        let mv = NMFMapView()
        mv.mapType = .basic
        mv.positionMode = .disabled
        mv.allowsScrolling = false
        mv.layer.cornerRadius = 20
        return mv
    }()
    
    // -- collectionView
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        return collectionView
    }()

    
    // -- 1. spotStackView
    lazy var spotLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .semiBold24
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        let normalImage = UIImage(named: "bookmarkIcon")
        let selectedImage = UIImage(named: "bookmarkIconSelected")
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var spotStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spotLabel, bookmarkButton])
        spotLabel.snp.makeConstraints {
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(10)
        }
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    // -- 2. locationStackView
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
        let stackView = UIStackView(arrangedSubviews: [locationIcon, locationLabel,dotIcon,mapIcon, distanceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    // -- 3 textView
     lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
         textView.textContainerInset = .zero
         textView.textContainer.lineFragmentPadding = 0
        textView.font = .regular14
        return textView
    }()
    
    // -- 4 Tags
    let tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        
        return collectionView
    }()
    
    // -- 5 경로 버튼
    lazy var routeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("경로 따라가기", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .mainBlue
        button.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        return button
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
    
    // MARK: - Selectors
    
    @objc private func bookmarkButtonTapped() {
        delegate?.bookmarkButtonTapped(self)
    }
    
    @objc private func routeButtonTapped() {
        delegate?.routeButtonTapped(self)
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        
    }
}


// MARK: - Layouts

extension ParticularView: LayoutProtocol {
    
    func setSubViews() {
        self.addSubview(scrollView)
        [map, collectionView, spotStackView, locationStackView, textView, tagsCollectionView, routeButton]
            .forEach { scrollView.subviews.first!.addSubview($0) }

    }
    
    func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        map.snp.makeConstraints {
            $0.top.equalTo(scrollView.subviews.first!.snp.top).offset(10)
            $0.height.equalTo(350)
            $0.leading.equalTo(scrollView.subviews.first!.snp.leading).offset(16)
            $0.trailing.equalTo(scrollView.subviews.first!.snp.trailing).offset(-16)
        }
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.top.equalTo(map.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
        }

        spotStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(15)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
        }
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(spotStackView.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(locationStackView.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(10)
            $0.leading.equalTo(map.snp.leading)
            $0.trailing.equalTo(map.snp.trailing).offset(-10)
            $0.height.equalTo(80)
        }
        
        routeButton.snp.makeConstraints {
            $0.top.equalTo(tagsCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
            $0.bottom.equalTo(scrollView.subviews.first!.snp.bottom).offset(-20)
        }
        
    }
    
}
