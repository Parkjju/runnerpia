//
//  PhotoCollectionViewCell.swift
//  runnerpia
//
//  Created by Jun on 2023/05/31.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    var selectedImage: UIImage?{
        didSet{
            setupUI()
        }
    }
    
    let addImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus")?.withTintColor(.textGrey01, renderingMode: .alwaysOriginal)
        return iv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .black
        
        return iv
    }()
    
    // MARK: 버튼 클릭이벤트가 컬렉션뷰에 먹히는 상태 -> 개선 필요
    let removeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(18)
        }
        btn.layer.cornerRadius = 10
        
        btn.setImage(UIImage(systemName: "xmark")!.scalePreservingAspectRatio(targetSize: CGSize(width: 8, height: 8)).withTintColor(.grey300, renderingMode: .alwaysOriginal), for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.grey300.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    var isAddButton: Bool = false{
        didSet{
            setupUI()
        }
    }
    
    // MARK: Lifecycle functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setLayout()
        setupUI()
    }
    
    // MARK: 초기화 후 추가버튼 UI를 어떻게 재조정할지
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setupUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        // MARK: addImage 셀 UI오류 예상후보 1. Constraints 중복 추가 -> 아님
        if(selectedImage!.isSymbolImage){
            self.backgroundColor = .grey100
            
            // MARK: 예상후보 2. 재사용 과정에서 imageView 인스턴스가 addImage 위를 덮음 -> 정답!
            imageView.snp.removeConstraints()
            self.contentView.backgroundColor = .grey100
            
            self.addImage.snp.makeConstraints {
                $0.centerX.equalTo(self.contentView.snp.centerX)
                $0.centerY.equalTo(self.contentView.snp.centerY)
                $0.width.equalTo(20)
                $0.height.equalTo(20)
            }
        }else{
            self.contentView.backgroundColor = .black
            imageView.snp.makeConstraints {
                $0.top.equalTo(self.snp.top)
                $0.leading.equalTo(self.snp.leading)
                $0.trailing.equalTo(self.snp.trailing)
                $0.bottom.equalTo(self.snp.bottom)
            }
            imageView.image = selectedImage
            
        }
    }
}

extension PhotoCollectionViewCell: LayoutProtocol{
    func setSubViews() {
        [addImage, removeButton].forEach { self.contentView.addSubview($0) }
        [imageView].forEach { self.addSubview($0) }
    }
    
    // MARK: estimated size를 통해 자동 재계산 되고있는지 확인 필요
    func setLayout() {
        removeButton.snp.makeConstraints {
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-5)
            $0.top.equalTo(self.contentView.snp.top).offset(5)
        }
    }
}
