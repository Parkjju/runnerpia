//
//  TagCollectionViewCell.swift
//  runnerpia
//
//  Created by Jun on 2023/05/24.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    var gradientLayer: CAGradientLayer!
    
    var tagName: String?{
        didSet{
            tagNameLabel.text = tagName!
        }
    }
    
    var isSecureTag: Bool = false{
        didSet{
            setUI()
        }
    }
    var isGradient: Bool = false{
        didSet{
            setUI()
        }
    }
    
    var isChecked: Bool = false{
        didSet{
            setUI()
        }
    }
    
    let tagNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setUI()
    }

    func setUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 10

        if(isChecked && isSecureTag){
            self.contentView.backgroundColor = hexStringToUIColor(hex: "#BBE2FF")
            tagNameLabel.textColor = .black
            return
        }else if(isChecked && !isSecureTag){
            self.contentView.backgroundColor = hexStringToUIColor(hex: "#FCDCBE")
            tagNameLabel.textColor = .black
            return
        }
    
        // 피그마 자동생성 코드
        if(isGradient){
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.contentView.bounds
            gradientLayer.colors = [hexStringToUIColor(hex: "#FCDCBE").cgColor,hexStringToUIColor(hex: "#BBE2FF").cgColor]
            self.contentView.layer.addSublayer(gradientLayer)
            tagNameLabel.textColor = .black
            return
        }
        
        if(isSecureTag){
            self.contentView.backgroundColor = hexStringToUIColor(hex: "#B1DEFD").withAlphaComponent(0.3)
            tagNameLabel.textColor = .grey700.withAlphaComponent(0.3)
        }else{
            self.contentView.backgroundColor = .orange200.withAlphaComponent(0.3)
            tagNameLabel.textColor = .grey700.withAlphaComponent(0.3)
        }
    }
}
extension TagCollectionViewCell: LayoutProtocol{
    func setSubViews() {
        [tagNameLabel].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        tagNameLabel.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(12)
            $0.trailing.equalTo(self.snp.trailing).offset(-12)
            $0.top.equalTo(self.snp.top).offset(6)
            $0.bottom.equalTo(self.snp.bottom).offset(-6)
        }
    }
}
