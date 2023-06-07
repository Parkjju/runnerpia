//
//  ReviewMainViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/06/07.
//

import UIKit
import NMapsMap

class ReviewMainViewController: UIViewController {

    // MARK: Properties
    var routeData: Route?{
        didSet{
            let reviewView = self.view as! ReviewMainView
            reviewView.routeData = routeData
        }
    }
    
    
    
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = ReviewMainView()
        self.view = view 
    }
    
    
}

extension ReviewMainViewController: ReviewDataDelegate{
    func getData() -> (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng]) {

        guard let navController = self.navigationController, navController.viewControllers.count >= 2 else {
            return (Date(), (0, 0), (0, 0), [])
        }
        
        let routeVC = navController.viewControllers[navController.viewControllers.count - 2] as! RouteViewController
        
        let view = routeVC.view as! RouteRecordView
        let timeTuple = (view.elapsedMinutes, view.elapsedSeconds)
        let today = view.today
        let distance = (view.accumulatedKilometer,view.accumulatedMeter)
        let coordinates = view.pathCoordinates
        
        return (today, timeTuple, distance, coordinates)
    }
}
