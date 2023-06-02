//
//  UserLocationManager.swift
//  runnerpia
//
//  Created by Jun on 2023/06/02.
//

import Foundation
import CoreLocation

class UserLocationManager{
    static let shared = CLLocationManager()
    
    func requestLocationPermissionAuthorization(){
        UserLocationManager.shared.requestAlwaysAuthorization()
        UserLocationManager.shared.startUpdatingLocation()
    }
}
