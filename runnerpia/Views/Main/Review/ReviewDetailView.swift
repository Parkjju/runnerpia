//
//  ReviewDetailView.swift
//  runnerpia
//
//  Created by Jun on 2023/06/08.
//

import UIKit

class ReviewDetailView: UIView {
    
    // MARK: Properties
    var delegate: PhotoCollectionViewCellEventDelegate?
    let reviewSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "경로에 대한 경험을 글로 남겨주세요"
        label.font = .semiBold18
        return label
    }()
    
    let reviewTextView: UITextView = {
        let tv = UITextView()
        tv.text = "최소 30자 이상 작성해주세요. (비방, 욕설을 포함한 관련없는 내용은 통보 없이 삭제될 수 있습니다."
        tv.font = UIFont.regular14
        tv.textColor = .textGrey02
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.grey200.cgColor
        tv.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        return tv
    }()
    
    let numberOfTextInput: UILabel = {
        let label = UILabel()
        label.text = "0 / 300"
        label.font = .medium14
        label.textColor = .textGrey01
        return label
    }()
    
    let photoSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "경험했던 경로의 사진을 등록해주세요"
        label.font = .semiBold18
        return label
    }()
    
    let photoCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 100) / 4, height: (UIScreen.main.bounds.width - 100) / 4)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Photo")
        cv.tag = 1
        return cv
    }()
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setSubViews()
        
        photoCollectionView.snp.removeConstraints()
        
        setLayout()
        setupController()
        updateCollectionViewHeight()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: helpers
    func setupController(){
        reviewTextView.delegate = self.parentViewController as! ReviewDetailViewController
        
        photoCollectionView.delegate = self.parentViewController as! ReviewDetailViewController
        photoCollectionView.dataSource = self.parentViewController as! ReviewDetailViewController
        
        delegate = self.parentViewController as! ReviewDetailViewController
    }
    
    func updateCollectionViewHeight(){
        // 안심태그 컬렉션뷰 dynamic height
        photoCollectionView.setNeedsLayout()
        photoCollectionView.layoutIfNeeded()
        
        if(photoCollectionView.contentSize.height > photoCollectionView.frame.height){
            photoCollectionView.snp.updateConstraints {
                $0.height.equalTo(photoCollectionView.contentSize.height)
            }
        }
    }
}

extension ReviewDetailView: LayoutProtocol{
    func setSubViews() {
        [reviewSectionLabel, reviewTextView, numberOfTextInput, photoSectionLabel, photoCollectionView].forEach {self.addSubview($0)}
    }
    
    func setLayout() {
        reviewSectionLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(reviewSectionLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.height.equalTo(200)
        }
        
        numberOfTextInput.snp.makeConstraints {
            $0.top.equalTo(reviewTextView.snp.bottom).offset(10)
            $0.trailing.equalTo(reviewTextView.snp.trailing)
        }
        
        photoSectionLabel.snp.makeConstraints {
            $0.top.equalTo(numberOfTextInput.snp.bottom).offset(20)
            $0.leading.equalTo(reviewTextView.snp.leading)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(photoSectionLabel.snp.bottom).offset(12)
            $0.leading.equalTo(reviewTextView.snp.leading)
            $0.trailing.equalTo(reviewTextView.snp.trailing)
            $0.height.equalTo(60)
        }
    }
}
