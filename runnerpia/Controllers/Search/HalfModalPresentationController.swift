//
//  HalfModalPresentationController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/02.
//

import UIKit

class HalfModalPresentationController: UIViewController {
    
    // MARK: - Properties
    
    var halfModalView = HalfModalView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
      view = halfModalView
  }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}
