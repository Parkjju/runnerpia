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
        
        configureSearchBar()
        
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
    
    private func configureSearchBar() {
        searchView.searchBar.placeholder = "시/구까지 입력해주세요."
        searchView.searchBar.showsCancelButton = true
        searchView.searchBar.backgroundImage = UIImage() // 상, 하단 줄 해제
        
    }
    
    private func configureDelegate() {
    }

}


extension SearchView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // SearchBar의 포커스 해제
    }
}
