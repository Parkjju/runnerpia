//
//  TabBarController.swift
//  runnerpia
//
//  Created by Jun on 2023/06/05.
//

import UIKit

// MARK: 1차 메모리 성능 개선
// MARK: 탭바 전환 메서드 구현으로 누적되는 메모리 해제
// MARK: 홈에서 다른 곳으로 전환될때도 구현 필요여부 체크
class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("hi")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedNavigationVC = viewController as! UINavigationController
        
        // MARK: 메모리상에 RecommendVC가 살아있으면 해제
        guard let _ = selectedNavigationVC.viewControllers.first as? RecommendViewController else {
            
            if(selectedNavigationVC.viewControllers.count == 0){
                selectedNavigationVC.pushViewController(RecommendViewController(), animated: false)
                return
            }else{
                
                let tabbarFirstNavigationVC = self.viewControllers!.first as! UINavigationController
                tabbarFirstNavigationVC.viewControllers.removeAll()
                return
            }
        }
        
        
        // MARK: 탭바 셀렉트 뷰컨이 경로 따라가기 Navigation VC면 RecommendVC 푸시
        
        
        
    
        
    }

}
