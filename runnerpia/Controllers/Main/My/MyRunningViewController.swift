//
//  MyRunningViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//


import UIKit
import CoreLocation

final class MyRunningViewController: UIViewController {
    
    // MARK: - Properties
    
    var myRunningView = MyRunningView()
    
    var data: Route? {
        didSet {
            self.myRunningView.tableView.reloadData()
        }
    }
    
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
    
    // ⭐️ 추후 수정
    func setUpData() -> Route {
        let firstData = Route(
            user: User(userId: "주영", nickname: "Jess"),
            routeName: "한강 잠실 러닝길",
            distance: 100,
            arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)],
            location: "ㅁ",
            runningTime: "",
            review: "300자가 어느 정도 되나",
            runningDate: "12월 31일 토요일 오후 6~9시",
            recommendedTags: ["1", "2"],
            secureTags: ["1", "2", "3"]
        )
        return firstData
    }
    
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
        
        cell.routeLabel.text = data?.routeName
        cell.dateLabel.text = data?.runningDate
        cell.timeLabel.text = data?.runningTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
}
