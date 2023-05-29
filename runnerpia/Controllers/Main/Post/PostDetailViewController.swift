//
//  PostDetailViewController.swift
//  runnerpia
//
//  Created by 박경준 on 2023/05/25.
//

import UIKit
import NMapsMap

class PostDetailViewController: UIViewController {
    
    var bindingData: (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng])?{
        didSet{
            let view = self.view as! PostDetailView
            view.bindingData = bindingData
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let postDetailView = PostDetailView()
        self.view = postDetailView
    }


}
