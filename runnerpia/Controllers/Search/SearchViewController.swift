//
//  SearchViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/29.
//


import UIKit

final class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    var searchView = SearchView()
    var searchController = UISearchController(searchResultsController: nil)
//    var searchController: UISearchController!
    
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
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "시/구까지 입력해주세요."
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.backgroundImage = UIImage()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
//        navigationItem.searchController = searchController
    }
    
    private func configureDelegate() {
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // SearchBar의 포커스 해제
    }

}




