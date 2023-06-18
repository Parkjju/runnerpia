//
//  MyRunningViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//


import UIKit
import CoreLocation

final class MyRunningViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    weak var emptyRecommendView: MyEmptyView?

    var routeData: [Route] = []  {
        didSet {
            let myRunningView = self.view as! MyRunningView
            myRunningView.tableView.reloadData()
        }
    }
    
    deinit {
        print("메모리 해제")
        if emptyRecommendView == nil {
            print("emptyRecommendView 인스턴스가 해제되었습니다.")
        }
    }


    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = MyRunningView()
        self.view = view
        
        configureNavigation()
        configureDelegate()
        
        // ⭐️ 추후 수정
        setUpData()
        
        configureUI()
        
    }
    
    
    
    // MARK: - Selectors
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureEmptyView() {
        let emptyView = MyEmptyView()
        emptyView.backgroundColor = .white
        emptyView.commentLabel.text = "등록된 추천 경로가 없어요. \n 나만의 러닝 경로를 추천해볼까요?"
        let attributedTitle = NSAttributedString(string: "러닝 시작하기", attributes: [
            NSAttributedString.Key.font: UIFont.semiBold16,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        emptyView.connectButton.setAttributedTitle(attributedTitle, for: .normal)
        emptyView.connectButton.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
        
        emptyRecommendView = emptyView
        view = emptyView

    }
    
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
        
        if routeData.isEmpty {
            let myRunningView = self.view as! MyRunningView
            self.view = emptyRecommendView
            emptyRecommendView?.isHidden = false
            myRunningView.isHidden = true
            configureEmptyView()
        } else {
            let myRunningView = self.view as! MyRunningView
            emptyRecommendView?.isHidden = true
            myRunningView.isHidden = false
            myRunningView.tableView.reloadData()
            myRunningView.tableView.register(MyRunningViewTableViewCell.self, forCellReuseIdentifier: "MyRunningCell")
            myRunningView.tableView.estimatedRowHeight = 167
            myRunningView.tableView.rowHeight = UITableView.automaticDimension
            myRunningView.commentLabel.text = "총 \(routeData.count)개"
        }
    }

    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "러닝 기록 내역"
        let image = UIImage(named: "previousButton")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func configureDelegate() {
        let myRunningView = self.view as! MyRunningView
        myRunningView.tableView.delegate = self
        myRunningView.tableView.dataSource = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
}

// MARK: - TableView Delegate

extension MyRunningViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRunningCell", for: indexPath) as! MyRunningViewTableViewCell
        cell.selectionStyle = .none
        let rowData = routeData[indexPath.section]
        cell.cellData = rowData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
}
