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
    
    //    var routeData: [Route] = []  {
    //        didSet {
    //            let myRunningView = self.view as! MyRunningView
    //            myRunningView.tableView.reloadData()
    //        }
    //    }
    
    
    var routeData: [RouteData] = []  {
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

        
    }
    
    
    
    private func configureUI() {
        
        let myRunningView = self.view as! MyRunningView
        emptyRecommendView?.isHidden = true
        myRunningView.isHidden = false
        myRunningView.tableView.reloadData()
        myRunningView.tableView.register(MyRunningViewTableViewCell.self, forCellReuseIdentifier: "MyRunningCell")
        myRunningView.tableView.estimatedRowHeight = 167
        myRunningView.tableView.rowHeight = UITableView.automaticDimension
        myRunningView.commentLabel.text = "총 \(routeData.count)개"
        
    }
    
    
    //    private func configureUI() {
    //        if routeData.isEmpty {
    //            let myRunningView = self.view as! MyRunningView
    //            self.view = emptyRecommendView
    //            emptyRecommendView?.isHidden = false
    //            myRunningView.isHidden = true
    //            configureEmptyView()
    //        } else {
    //            let myRunningView = self.view as! MyRunningView
    //            emptyRecommendView?.isHidden = true
    //            myRunningView.isHidden = false
    //            myRunningView.tableView.reloadData()
    //            myRunningView.tableView.register(MyRunningViewTableViewCell.self, forCellReuseIdentifier: "MyRunningCell")
    //            myRunningView.tableView.estimatedRowHeight = 167
    //            myRunningView.tableView.rowHeight = UITableView.automaticDimension
    //            myRunningView.commentLabel.text = "총 \(routeData.count)개"
    //        }
    //    }
    
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
        let routeData = routeData[indexPath.row]
        cell.routeLabel.text = routeData.routeName
        cell.dateLabel.text = routeData.runningDate
        cell.locationLabel.text = routeData.location
        if let distance = routeData.distance {
            cell.distanceLabel.text = String(distance)
        } else {
            cell.distanceLabel.text = "" 
        }
        cell.timeLabel.text = routeData.runningTime
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
    
}
