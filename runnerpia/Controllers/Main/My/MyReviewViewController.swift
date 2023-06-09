//
//  MyReviewViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//


import UIKit

final class MyReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var myReviewView = MyReviewView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        
    }
    
    override func loadView() {
        view = myReviewView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        myReviewView.tableView.register(MyReviewTableViewCell.self, forCellReuseIdentifier: "MyReviewCell")
        myReviewView.tableView.estimatedRowHeight = 167
        myReviewView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "나의 리뷰"
    }
    
    private func configureDelegate() {
        myReviewView.tableView.delegate = self
        myReviewView.tableView.dataSource = self
    }
    
    
    
}

// MARK: - TableView Delegate

extension MyReviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCell", for: indexPath) as! MyReviewTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}
