//
//  PostViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/05/24.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let postView = PostView()
        self.view = postView
    }
}

extension PostViewController: PostViewEventDelegate{
    func registerButtonTapped() {
        // 뷰 생성 및 present
        let postDetailVC = PostDetailViewController()
        postDetailVC.modalPresentationStyle = .fullScreen
        
        self.present(postDetailVC, animated: true)
    }
}
