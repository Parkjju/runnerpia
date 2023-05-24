//
//  RouteViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit
import CoreLocation
import NMapsMap

final class RouteViewController: UIViewController {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = RouteRecordView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
}

extension RouteViewController: PostDataDelegate{
    func getData() -> ((TimeInterval,TimeInterval), Date, Int, [NMGLatLng]) {
        let view = self.view as! RouteRecordView
        let timeTuple = (view.elapsedMinutes, view.elapsedSeconds)
        let today = view.today
        let distance = view.accumulatedDistance
        let coordinates = view.pathCoordinates
        print((timeTuple, today, distance, coordinates))
        return (timeTuple, today, distance, coordinates)
    }
}
