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
    
    var routeData: [RouteData] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        return indicator
    }()
    
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
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
        
        
        // ⭐️ 추후 수정
        setUpData()
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
        let routeId = 52
        APIClient.getRouteData(routeId: routeId) { result in
            switch result {
            case .success(let routeData):
                self.routeData = [routeData]
                print("Received routeData:", routeData)
                
                DispatchQueue.main.async {
                    let myRunningView = self.view as! MyRunningView
                    self.emptyRecommendView?.isHidden = true
                    myRunningView.isHidden = false
                    myRunningView.tableView.reloadData()
                    myRunningView.tableView.register(MyRunningViewTableViewCell.self, forCellReuseIdentifier: "MyRunningCell")
                    myRunningView.tableView.estimatedRowHeight = 167
                    myRunningView.tableView.rowHeight = UITableView.automaticDimension
                    myRunningView.commentLabel.text = "총 \(self.routeData.count)개"
                    self.activityIndicator.stopAnimating()
                }
                
            case .failure(let error):
                print("Error:", error)
                
                DispatchQueue.main.async {
                    let myRunningView = self.view as! MyRunningView
                    self.view = self.emptyRecommendView
                    self.emptyRecommendView?.isHidden = false
                    myRunningView.isHidden = true
                    self.configureEmptyView()
                    self.activityIndicator.stopAnimating() // 데이터 받아오기가 실패해도 비활성화
                }
                
            }
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
    
    private func formateRunningDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM월 dd일 EEEE"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    private func formateRunningTime(_ timeString: String) -> String {
        let timeComponents = timeString.split(separator: ":")
        if timeComponents.count == 3 {
            if let hours = Int(timeComponents[0]), let minutes = Int(timeComponents[1]), let seconds = Int(timeComponents[2]) {
                let totalSeconds = hours * 3600 + minutes * 60 + seconds
                let totalMinutes = Int(round(Double(totalSeconds) / 60.0))
                return "\(totalMinutes)분"
            }
        }
        return ""
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
        
        if let runningDate = routeData.runningDate {
            cell.dateLabel.text = formateRunningDate(runningDate)
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.locationLabel.text = routeData.location
        if let distance = routeData.distance {
            cell.distanceLabel.text = String(distance) + "km"
        } else {
            cell.distanceLabel.text = ""
        }
        cell.timeLabel.text = "\(routeData.runningTime)분"
        
        if let runningTime = routeData.runningTime {
            cell.timeLabel.text = formateRunningTime(runningTime)
        } else {
            cell.timeLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
    
}
