//
//  ReviewMainViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/06/07.
//

import UIKit
import NMapsMap

class ReviewMainViewController: UIViewController {

    // MARK: Properties
    var routeData: Route?{
        didSet{
            let reviewView = self.view as! ReviewMainView
            reviewView.routeData = routeData
        }
    }
    
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = ReviewMainView()
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let reviewMainView = self.view as! ReviewMainView
        reviewMainView.updateCollectionViewHeight()
    }
}

extension ReviewMainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.visibleCells[indexPath.item] as! TagCollectionViewCell
        cell.isChecked = !cell.isChecked
    }
}

extension ReviewMainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 1){
            return globalSecureTags.count
        }else if (collectionView.tag == 2){
            return globalRecommendedTags.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
        if(collectionView.tag == 1){
            cell.isSecureTag = true
            cell.tagName = globalSecureTags[indexPath.item]
        }else if(collectionView.tag == 2){
            cell.isSecureTag = false
            cell.tagName = globalRecommendedTags[indexPath.item]
        }
        
        return cell
    }
}

extension ReviewMainViewController: ReviewDataDelegate{
    func getData() -> (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng]) {

        guard let navController = self.navigationController, navController.viewControllers.count >= 2 else {
            return (Date(), (0, 0), (0, 0), [])
        }
        
        guard let routeVC = navController.viewControllers[navController.viewControllers.count - 2] as? RouteViewController else {
            return (Date(), (0, 0), (0, 0), [])
        }
        
        let view = routeVC.view as! RouteRecordView
        let timeTuple = (view.elapsedMinutes, view.elapsedSeconds)
        let today = view.today
        let distance = (view.accumulatedKilometer,view.accumulatedMeter)
        let coordinates = view.pathCoordinates
        
        return (today, timeTuple, distance, coordinates)
    }
    
    func nextView() {
        let reviewDetailVC = ReviewDetailViewController()
        reviewDetailVC.view.backgroundColor = .white
        navigationController?.pushViewController(reviewDetailVC, animated: true)
    }
}
