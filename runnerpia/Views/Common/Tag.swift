//
//  Tag.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit

class Tag: UIView {
    
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
    
    func setUI(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    
        // 피그마 자동생성 코드
        if(isGradient){
            let layer0 = CAGradientLayer()
            layer0.colors = [
              UIColor(red: 0.733, green: 0.886, blue: 1, alpha: 1).cgColor,
              UIColor(red: 0.988, green: 0.863, blue: 0.745, alpha: 1).cgColor
            ]
            layer0.locations = [0, 1]
            layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
            layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
            layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.71, b: 1, c: -1, d: 1.32, tx: 0.66, ty: -0.66))
            layer0.bounds = self.bounds.insetBy(dx: -0.5 *  self.bounds.size.width, dy: -0.5 * self.bounds.size.height)
            layer0.position = self.center
            self.layer.addSublayer(layer0)
            
            return
        }
        
        if(isSecureTag){
            self.backgroundColor = .secureTagColor
        }else{
            self.backgroundColor = .recommendedTagColor
        }
    }
}

extension Tag: LayoutProtocol{
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
        
        self.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
}
