//
//  HalfSizePresentationController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/05.
//

import UIKit
import NMapsMap

class HalfSizePresentationController: UIPresentationController {
    
    // MARK: - Properties
    
    let blurEffectView = UIView()

    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var check: Bool = false
    
    // MARK: - Selectors
    
    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true) {
            let searchViewController = self.presentingViewController as! SearchViewController
            searchViewController.pathOverlay.color = .clear
            searchViewController.locationManager.startUpdatingLocation()
            searchViewController.searchView.map.positionMode = .direction
            print(searchViewController)
        }
    }
    
    // MARK: - LifeCycles
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    // 모달이 없어질 때 검은색 배경을 슈퍼뷰에서 제거
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0}, completion: { _ in self.blurEffectView.removeFromSuperview()})
    }
    
    // 모달의 크기가 조절됐을 때 호출되는 함수
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        blurEffectView.frame = containerView!.bounds
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView!.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0.1 }, completion: nil)
        
        //                var presentingVC = presentingViewController as! HalfModalPresentationController
        print(self.presentingViewController)
        var searchVC = self.presentingViewController as! SearchViewController
        searchVC.pathOverlay.color = .blue400
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            return CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: theView.bounds.width, height: 300)
        }
    }
}
