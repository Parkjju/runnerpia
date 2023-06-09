//
//  MyReviewTableViewCell.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/08.
//

import UIKit
import SnapKit

class MyReviewTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    // MARK: - Properties
    
    // ----- 1. 가로 스택뷰
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 31일 토요일 오후 6~9시"
        label.font = UIFont.regular12
        return label
    }()
    
    let firstLineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = UIFont.regular12
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "500분"
        label.font = UIFont.regular12
        return label
    }()
    
    let secondLineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = UIFont.regular14
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "100km"
        label.font = UIFont.regular12
        return label
    }()
    
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ dateLabel,firstLineLabel, timeLabel, secondLineLabel, distanceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.titleLabel?.font = .regular12
        button.setTitleColor(.grey500, for: .normal)
        return button
    }()

    
    // ----- 2. collectionView (사진)
    
    let photoCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 100) / 4, height: (UIScreen.main.bounds.width - 100) / 4)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        cv.tag = 3
        return cv
    }()
    
    // ----- 3.
    
    let introduceTextField: UITextView = {
        let tv = UITextView()
        tv.text = "300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글 300자가 얼마나 되는지 보려고 쓰는 글"
        tv.font = UIFont.regular14
        tv.textColor = .textGrey02
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.grey200.cgColor
        tv.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        return tv
    }()
    
    // ----- 4. collectionView (태그)
    
    let tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        cv.tag = 1
        
        return cv
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
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
            $0.top.equalTo(dateStackView.snp.top)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(photoCollectionView.snp.top).offset(10)
            $0.top.equalTo(dateStackView.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.leading.equalTo(introduceTextField.snp.leading)
            $0.trailing.equalTo(introduceTextField.snp.leading)
            $0.top.equalTo(introduceTextField.snp.bottom).offset(10)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
            $0.height.greaterThanOrEqualTo(80)
        }
        
        
    }
}
