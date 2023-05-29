//
//  SearchViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//


import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var searchView = SearchView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        
    }
    
    override func loadView() {
        view = searchView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureDelegate() {
    }

 
    // MARK: - Layout Extension
}
