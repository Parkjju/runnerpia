//
//  Divider.swift
//  runnerpia
//
//  Created by Jun on 2023/05/29.
//

import UIKit

class Divider: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        self.backgroundColor = .
    }

}
