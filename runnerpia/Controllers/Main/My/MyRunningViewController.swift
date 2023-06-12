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
    
    var routeData: [Route] = []  {
        didSet {
            self.myRunningView.tableView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        
        // ⭐️ 추후 수정
        setUpData()
        
        configureUI()

    }
    
    override func loadView() {
        view = myRunningView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    // ⭐️ 추후 수정
    func setUpData() {
        let firstData = Route(
            user: User(userId: "주영", nickname: "Jess"),
            routeName: "한강 잠실 러닝길",
            distance: 100,
            arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)],
            location: "송파구 잠실동",
            runningTime: "100",
            review: "300자가 어느 정도 되나 300자가 어느 정도 되나 300자가 어느 정도 되나 300자가 어느 정도 되나 300자가 어느 정도 되나",
            runningDate: "12월 31일 토요일 오후 6~9시",
            recommendedTags: ["1", "2"],
            secureTags: ["1", "2", "3"]
        )
        
        let secondData = Route(
            user: User(userId: "주영", nickname: "Jess"),
            routeName: "송정 뚝방로",
            distance: 200,
            arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)],
            location: "성동구 송정도",
            runningTime: "200",
            review: "300자가 어느 정도 되나 1",
            runningDate: "6월 12일 월요일 오후 6~9시",
            recommendedTags: ["1", "2"],
            secureTags: ["1", "2", "3"]
        )
        
        let thirdData = Route(
            user: User(userId: "주영", nickname: "Jess"),
            routeName: "용인시 수지구",
            distance: 100,
            arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),
                         CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)],
            location: "수지구청역",
            runningTime: "300",
            review: "300자가 어느 정도 되나3",
            runningDate: "6월 11일 일요일 오후 6~9시",
            recommendedTags: ["1", "2"],
            secureTags: ["1", "2", "3"]
        )
        
        routeData.append(firstData)
        routeData.append(secondData)
        routeData.append(thirdData)
    }
    
    private func configureUI() {
        myRunningView.tableView.register(MyRunningViewTableViewCell.self, forCellReuseIdentifier: "MyRunningCell")
        myRunningView.tableView.estimatedRowHeight = 167
        myRunningView.tableView.rowHeight = UITableView.automaticDimension
        
        myRunningView.commentLabel.text = "총 \(routeData.count)개"
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return routeData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRunningCell", for: indexPath) as! MyRunningViewTableViewCell

        let rowData = routeData[indexPath.section]
        cell.cellData = rowData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
}
