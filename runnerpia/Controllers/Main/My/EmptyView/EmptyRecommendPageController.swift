//
//  EmptyRecommendPageController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//

import UIKit

final class EmptyRecommendPageController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = MyEmptyView()
        self.view = view
        
        configureNavigation()
        configureDelegate()
        configureUI()
        
    }

    
    // MARK: - Selectors
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func connectButtonTapped() {
        print("러닝 시작하기")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        let emptyRecommendView = self.view as! MyEmptyView
        emptyRecommendView.commentLabel.text = "등록된 추천 경로가 없어요. \n 나만의 러닝 경로를 추천해볼까요?"
        let attributedTitle = NSAttributedString(string: "러닝 시작하기", attributes: [
            NSAttributedString.Key.font: UIFont.semiBold16,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        emptyRecommendView.connectButton.setAttributedTitle(attributedTitle, for: .normal)
        emptyRecommendView.connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "추천 경로 등록 내역"
        let image = UIImage(named: "previousButton")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func configureDelegate() {
        
    }
}
