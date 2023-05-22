//
//  Tag.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit

class Tag: UIView {
    
    var isSecureOrRecommend: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
