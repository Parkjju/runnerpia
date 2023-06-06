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
        
        setupNavigationBar()
    }
    
    // MARK: LifeCycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Selectors
    @objc func closeButtonTapped(){
        UserLocationManager.shared.stopUpdatingLocation()
        self.navigationController?.dismiss(animated: true)
    }
    
    // MARK: Helpers
    func setupNavigationBar(){
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}

extension PostViewController: PostViewEventDelegate{
    func registerButtonTapped() {
        // 뷰 생성 및 present
        let postDetailVC = PostDetailViewController()
        postDetailVC.modalPresentationStyle = .fullScreen
        
        // 임시데이터 바인딩
        let postView = self.view as! PostView
        postDetailVC.bindingData = postView.delegate!.getData()
        
        self.navigationController?.pushViewController(postDetailVC, animated: false)
    }
}
