//
//  MyRunningViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//


import UIKit

final class MyRunningViewController: UIViewController {
    
    // MARK: - Properties
    
    var myRunningView = MyRunningView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureUI()
        configureDelegate()
        
    }
    
    override func loadView() {
        view = myRunningView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        myRunningView.tableView.register(MyRunningViewTableViewCell.self, forCellReuseIdentifier: "MyRunningCell")
        myRunningView.tableView.estimatedRowHeight = 167
        myRunningView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "러닝 기록 내역"
    }
    
    private func configureDelegate() {
        myRunningView.tableView.delegate = self
        myRunningView.tableView.dataSource = self

    }
    
}

// MARK: - TableView Delegate

extension MyRunningViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRunningCell", for: indexPath) as! MyRunningViewTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
}
