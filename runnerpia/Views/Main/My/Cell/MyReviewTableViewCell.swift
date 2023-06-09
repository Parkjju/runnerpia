//
//  MyReviewTableViewCell.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/08.
//

import UIKit
import SnapKit

class MyReviewTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var files = [#imageLiteral(resourceName: "random6"), #imageLiteral(resourceName: "random4"), #imageLiteral(resourceName: "random5"), #imageLiteral(resourceName: "random1")]
    
    // MARK: - Properties
    
    // ----- 1. 가로 스택뷰
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 31일 토요일 오후 6~9시"
        label.font = UIFont.regular12
        label.textColor = .grey700
        return label
    }()
    
    let firstLineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = UIFont.regular12
        label.textColor = .grey700
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "500분"
        label.font = UIFont.regular12
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
        label.text = "100km"
        label.font = UIFont.regular12
        label.textColor = .grey700
        return label
    }()
    
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ dateLabel,firstLineLabel, timeLabel, secondLineLabel, distanceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
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
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 100) / 4, height: (UIScreen.main.bounds.width - 100) / 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        collectionView.tag = 1
        return collectionView
    }()
    
    // ----- 3.
    
    let introduceTextField: UITextView = {
        let textView = UITextView()
        textView.text = "300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글"
        textView.font = UIFont.regular14
        textView.textColor = .textGrey02
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.grey200.cgColor
        textView.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
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
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        introduceTextField.delegate = self
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}

// MARK: - Layouts

extension MyReviewTableViewCell: LayoutProtocol {
    func setSubViews() {
        [ dateStackView, nextButton, photoCollectionView, introduceTextField, tagsCollectionView ]
            .forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(5)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(photoCollectionView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.top.equalTo(introduceTextField.snp.bottom).offset(10)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
            $0.height.greaterThanOrEqualTo(80)
        }
    }
}

extension MyReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            
            cell.imageView.image = files[indexPath.item]
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
