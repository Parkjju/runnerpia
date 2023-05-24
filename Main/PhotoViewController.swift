//
//  PhotoViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/23.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    let photoView = PhotoView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
    }
    
    override func loadView() {
        view = photoView
    }
    
    
    
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.white ]
        navigationItem.title = "1/3"
        if let backButtonImage = UIImage(systemName: "chevron.backward") {
            let leftBarButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = leftBarButton
        }

    }
    
    
    
    // MARK: - Layout Extension
}
