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
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserLocationManager.shared.stopUpdatingLocation()
    }
    
    func fetchData(){
        let view = self.view as! RecommendView
        APIClient.getRoute(routeId: 1) { result in
            switch(result){
            case .success(let mainRoute):
                print(mainRoute)
                view.indicatorView.stopAnimating()
                view.indicatorView.hidesWhenStopped = true
            case .failure(let error):
                print(error)
            }
        }
    }

}
