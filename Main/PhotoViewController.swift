//
//  PhotoViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/23.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func loadView() {
        view = UIView()
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .mainBlue
    }
    
    
    
    // MARK: - Layout Extension
}
