//
//  PaticularRouteController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/22.
//


import UIKit

final class ParticularRouteController: UIViewController {
    
    // MARK: - Properties
    var particularView = ParticularView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        
    }
    
    override func loadView() {
        view = particularView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        
    }
    
    private func configureNavigation() {
    }
    
    private func configureDelegate() {
    }
    
    // MARK: - Layout Extension
}
