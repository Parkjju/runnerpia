//
//  PostDetailViewController.swift
//  runnerpia
//
//  Created by 박경준 on 2023/05/25.
//

import UIKit
import NMapsMap

class PostDetailViewController: UIViewController {
    
    var bindingData: (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng])?{
        didSet{
            let view = self.view as! PostDetailView
            view.bindingData = bindingData
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let postDetailView = PostDetailView()
        self.view = postDetailView
    }


}

extension PostDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 의존성을 삭제하는 코드?
        // 서브뷰 인덱싱으로 하면 추후 뷰가 추가될 경우 코드가 꼬임 -> tag속성으로 처리
        if(collectionView.tag == 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
            switch(indexPath.item){
            case 0:
                cell.isSecureTag = true
                cell.tagName = globalSecureTags[indexPath.item]
            case 1:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 2:
                cell.tagName = "+3"
                cell.isGradient = true
            case 3:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 4:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[2]
            case 5:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[3]
            default:
                break
            }
            return cell
        }else if(collectionView.tag == 2){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
            switch(indexPath.item){
            case 0:
                cell.isSecureTag = true
                cell.tagName = globalSecureTags[indexPath.item]
            case 1:
                cell.isSecureTag = true
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 2:
                cell.tagName = "+3"
                cell.isGradient = true
            case 3:
                cell.isSecureTag = true
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 4:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[2]
            case 5:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[3]
            default:
                break
            }
            
            
            return cell
        }else{
            return UICollectionViewCell()
        }
        
        
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 50)
    }
}
