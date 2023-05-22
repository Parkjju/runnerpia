//
//  UIView.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit

// MARK: UIView에서 parent ViewController를 찾아주는 확장 함수
extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
