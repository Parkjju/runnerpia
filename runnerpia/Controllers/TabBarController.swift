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
    
    //    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    //        let selectedNavigationVC = viewController as! UINavigationController
    //        let recommendNavigationVC = tabBarController.viewControllers?.first as! UINavigationController
    //
    //
    //        // MARK: 메모리상에 RecommendVC가 살아있으면 해제
    //        guard let _ = selectedNavigationVC.viewControllers.first as? RecommendViewController else {
    //
    //            if(recommendNavigationVC.viewControllers.count == 0){
    //                recommendNavigationVC.pushViewController(RecommendViewController(), animated: false)
    //                return
    //            }else{
    //                // MARK: removeAll VS removeSubrange로 테이블뷰 목록은 살려둘지
    //                // MARK: 다른 뷰들 통신하는 과정에서 성능 저하가 심해지면 removeAll로 모든 지도 데이터들을 삭제해줘야됨
    //                recommendNavigationVC.viewControllers.removeAll()
    //                //                recommendNavigationVC.viewControllers.removeSubrange(1..<recommendNavigationVC.viewControllers.count)
    //                return
    //            }
    //        }
    //    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedNavigationVC = viewController as! UINavigationController
        let recommendNavigationVC = tabBarController.viewControllers?.first as! UINavigationController
        let myPageNavigationVC = tabBarController.viewControllers?[2] as! UINavigationController
        
        if selectedNavigationVC == recommendNavigationVC {
            if recommendNavigationVC.viewControllers.count == 0 {
                recommendNavigationVC.pushViewController(RecommendViewController(), animated: false)
            } else if recommendNavigationVC.viewControllers.count > 1 {
                recommendNavigationVC.viewControllers.removeLast(recommendNavigationVC.viewControllers.count - 1)
            }
        } else if selectedNavigationVC == myPageNavigationVC {
            if myPageNavigationVC.viewControllers.count == 0 {
                myPageNavigationVC.pushViewController(MyPageViewController(), animated: false)
            } else if myPageNavigationVC.viewControllers.count > 1 {
                myPageNavigationVC.viewControllers.removeLast(myPageNavigationVC.viewControllers.count - 1)
            }
        }
        
    }
    
    
}
