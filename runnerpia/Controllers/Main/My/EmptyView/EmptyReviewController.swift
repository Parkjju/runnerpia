//
//  EmptyReviewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//

import UIKit

final class EmptyReviewController: UIViewController {
    
    // MARK: - Properties
    var emptyReviewView = MyEmptyView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        
    }
    
    override func loadView() {
        view = emptyReviewView
    }
    
    
    // MARK: - Selectors
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func connectButtonTapped() {
        print("추천 경로 보러가기")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        emptyReviewView.commentLabel.text = "작성한 리뷰가 없어요. \n 나만의 러닝 경로를 추천해볼까요?"
        let attributedTitle = NSAttributedString(string: "추천 경로 보러가기", attributes: [
            NSAttributedString.Key.font: UIFont.semiBold16,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        emptyReviewView.connectButton.setAttributedTitle(attributedTitle, for: .normal)
        emptyReviewView.connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "작성한 리뷰"
        let image = UIImage(named: "previousButton")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func configureDelegate() {
    }
}
