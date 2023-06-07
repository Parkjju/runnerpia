//
//  ReviewMainViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/06/07.
//

import UIKit

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
