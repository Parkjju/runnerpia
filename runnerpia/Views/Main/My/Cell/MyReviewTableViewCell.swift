//
//  MyReviewTableViewCell.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/08.
//

import UIKit
import SnapKit

class MyReviewTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var files = [#imageLiteral(resourceName: "random6"), #imageLiteral(resourceName: "random4")]
    
    var cellData: Route? {
        didSet {
            setData()
        }
    }
    
    // MARK: - Properties
    
    // --- 0. 제목
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBold18
        label.textColor = .black
        return label
    }()

    
    let labelsContainerView = UIView()

    
//     ----- 1. 첫번째줄
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .grey700
        return label
    }()

    let firstLineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = .regular12
        label.textColor = .grey700
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .grey700
        return label
    }()

    let secondLineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = UIFont.regular14
        label.textColor = .grey700
        return label
    }()

    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular12
        label.textColor = .grey700
        return label
    }()

    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ dateLabel,firstLineLabel, timeLabel, secondLineLabel, distanceLabel ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.titleLabel?.font = .regular12
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    // ----- 2. collectionView (사진)
    
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        
        let numberOfColumns: CGFloat = 3
//        let itemWidth = (UIScreen.main.bounds.width - (numberOfColumns) * layout.minimumInteritemSpacing) / numberOfColumns
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.identifier)
        collectionView.tag = 1
        return collectionView
    }()
    
    // ----- 3.
    
    
    
    let introduceTextField: UITextView = {
        let textView = UITextView()
        textView.text = "300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글"
        textView.font = UIFont.regular14
        textView.textColor = .textGrey02
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
        
        return textView
    }()
    
    // ----- 4. collectionView (태그)
    
    let tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        collectionView.tag = 2
        
        return collectionView
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        introduceTextField.delegate = self
        photoCollectionView.setNeedsLayout()
        photoCollectionView.layoutIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func setData() {
        guard let data = cellData else {
            return
        }
        
        locationLabel.text = data.routeName
        dateLabel.text = data.runningDate
        
        if let runningTime = data.runningTime {
            timeLabel.text = "\(runningTime)분"
        } else {
            timeLabel.text = nil
        }
        
        if let distance = data.distance {
            let formattedDistance = String(format: "%.0f", distance)
            distanceLabel.text = "\(formattedDistance)km"
        } else {
            distanceLabel.text = nil
        }
        
        introduceTextField.text = data.review
    }
    
}

// MARK: - Layouts

extension MyReviewTableViewCell: LayoutProtocol {
    func setSubViews() {
        
        [ locationLabel, dateStackView, nextButton, photoCollectionView, introduceTextField, tagsCollectionView ]
            .forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
                
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.height.equalTo((UIScreen.main.bounds.width - 32 - 50) / 3)
        }
        
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(photoCollectionView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.height.equalTo(40)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.top.equalTo(introduceTextField.snp.bottom).offset(10)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
        }
    }
}

extension MyReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (UIScreen.main.bounds.width - 32 - 50) / 3, height: (UIScreen.main.bounds.width - 32 - 50) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return 3
        } else if collectionView.tag == 2 {
            return 3
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewCollectionViewCell.identifier, for: indexPath) as? MyReviewCollectionViewCell else { return UICollectionViewCell() }
    
            if indexPath.item < files.count {
                cell.imageView.image = files[indexPath.item].scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100))
            } else {
                cell.imageView.image = UIImage(named: "placeholderImage")
            }
            
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.cornerRadius = 10
            
            return cell
            
        } else {
            let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
            
            switch(indexPath.item){
            case 0:
                cell.isSecureTag = true
                cell.tagName = globalSecureTags[indexPath.item]
            case 1:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 2:
                cell.tagName = "+3"
                cell.isGradient = true
            default:
                break
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
