//
//  MyReviewViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//


import UIKit
import CoreLocation

final class MyReviewViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    weak var emptyReviewView: MyEmptyView?
        
    var routeData: [Route] = []  {
        didSet {
            let myReviewView = self.view as! MyReviewView
            myReviewView.tableView.reloadData()
        }
    }
    
    let secondLineView: Divider = {
        let divider = Divider()
        divider.backgroundColor = .grey100
        return divider
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = MyReviewView()
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
        emptyView.commentLabel.text = "작성한 리뷰가 없어요. \n 나만의 러닝 경로를 추천해볼까요?"
        let attributedTitle = NSAttributedString(string: "추천 경로 보러가기", attributes: [
            NSAttributedString.Key.font: UIFont.semiBold16,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        emptyView.connectButton.setAttributedTitle(attributedTitle, for: .normal)
        emptyView.connectButton.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
        
        emptyReviewView = emptyView
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
            let myReviewView = self.view as! MyReviewView
            self.view = emptyReviewView
            emptyReviewView?.isHidden = false
            myReviewView.isHidden = true
            configureEmptyView()
        } else {
            let myReviewView = self.view as! MyReviewView
            myReviewView.tableView.register(MyReviewTableViewCell.self, forCellReuseIdentifier: "MyReviewCell")
            myReviewView.tableView.estimatedRowHeight = 167
            myReviewView.tableView.rowHeight = UITableView.automaticDimension
            myReviewView.tableView.separatorStyle = .none

            myReviewView.commentLabel.text = "총 \(routeData.count)개"
        }
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "나의 리뷰"
        let image = UIImage(named: "previousButton")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func configureDelegate() {
        let myReviewView = self.view as! MyReviewView
        myReviewView.tableView.delegate = self
        myReviewView.tableView.dataSource = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    
}

// MARK: - TableView Delegate

extension MyReviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return routeData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCell", for: indexPath) as! MyReviewTableViewCell
        cell.selectionStyle = .none
        let rowData = routeData[indexPath.section]
        cell.cellData = rowData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
}

