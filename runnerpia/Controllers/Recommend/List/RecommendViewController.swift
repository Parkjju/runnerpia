//
//  RecommendViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit

class RecommendViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recommendView = RecommendView()
        self.view = recommendView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserLocationManager.shared.stopUpdatingLocation()
    }

}
