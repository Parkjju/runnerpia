//
//  RouteViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit
import CoreLocation

final class RouteViewController: UIViewController {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = RouteRecordView()
        
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
}
