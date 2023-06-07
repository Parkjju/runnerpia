//
//  LoginViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    var myPageView = MyPageView()
    
    
    // MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
    }
    
    override func loadView() {
        view = myPageView
    }
    
    // MARK: - Selectors
    
    @objc func settingButtonTapped() {
        print("세팅 버튼 클릭")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigation() {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let titleLabel = UILabel()
        titleLabel.text = "마이페이지"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = .semiBold16
        titleLabel.sizeToFit()

        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let image = UIImage(named: "settings")
        let renderedImage = image?.withRenderingMode(.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: renderedImage, style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    private func configureDelegate() {
        myPageView.delegate = self
    }
    
}

// MARK: -  Delegate

extension MyPageViewController: MyPageViewDelegate {
    
    func recommendButtonTapped(_ myPageView: MyPageView) {
        let emptyRecommendPageController = EmptyRecommendPageController()
        navigationController?.pushViewController(emptyRecommendPageController, animated: true)
    }
    
    func runningRecodeButtonTapped(_ myPageView: MyPageView) {
        print("러닝 기록 내역")
    }
    
    func reviewButtonTapped(_ myPageView: MyPageView) {
        print("작성한 리뷰")
        let emptyReviewController = EmptyReviewController()
        navigationController?.pushViewController(emptyReviewController, animated: true)

    }
    
    func logoutButtonTapped(_ myPageView: MyPageView) {
        print("로그아웃")
    }
    
    
}
