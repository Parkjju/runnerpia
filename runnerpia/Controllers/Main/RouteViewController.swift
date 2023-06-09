//
//  RouteViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit
import NMapsMap

final class RouteViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = RouteRecordView()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
    }
    
    // MARK: - Selectors
    @objc func closeButtonTapped(){
        UserLocationManager.shared.stopUpdatingLocation()
        self.navigationController?.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    func setupNavigationBar(){
        let button = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = button
    }
}

extension RouteViewController: PostDataDelegate{
    // MARK: 피그마 순서 - 날짜 / 소요시간 / 거리 / 폴리라인 좌표
    func getData() -> (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng]) {
        let view = self.view as! RouteRecordView
        let timeTuple = (view.elapsedMinutes, view.elapsedSeconds)
        let today = view.today
        let distance = (view.accumulatedKilometer,view.accumulatedMeter)
        let coordinates = view.pathCoordinates
        
        return (today, timeTuple, distance, coordinates)
    }
}

extension RouteViewController: ChangeViewDelegate{
    func nextView() {
        let routeRecordView = self.view as! RouteRecordView
        
        guard let routeData = routeRecordView.routeData else{
            let postVC = PostViewController()
            postVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(postVC, animated: false)
            return
        }
        
        let reviewVC = ReviewMainViewController()
        reviewVC.routeData = routeData
        reviewVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(reviewVC, animated: false)
    }
}
