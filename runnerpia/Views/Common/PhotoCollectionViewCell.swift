//
//  PhotoCollectionViewCell.swift
//  runnerpia
//
//  Created by Jun on 2023/05/31.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let addImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus")?.withTintColor(.textGrey01, renderingMode: .alwaysOriginal)
        return iv
    }()
    
    var isAddButton: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        if(isAddButton){
            self.backgroundColor = .grey100
            
//            self.addImage.snp.makeConstraints {
//                $0.centerX.equalTo(self.snp.centerX)
//                $0.centerY.equalTo(self.snp.centerY)
//                $0.width.equalTo(20)
//                $0.height.equalTo(20)
//            }
        }
    }
}
