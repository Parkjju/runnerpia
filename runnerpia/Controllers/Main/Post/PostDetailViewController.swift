//
//  PostDetailViewController.swift
//  runnerpia
//
//  Created by 박경준 on 2023/05/25.
//

import UIKit

class PostDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let postDetailView = PostDetailView()
        self.view = postDetailView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
