//
//  UIControl.swift
//  runnerpia
//
//  Created by Jun on 2023/05/15.
//

import UIKit

// MARK: 셀렉터 클로저 형태로 추가
extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
