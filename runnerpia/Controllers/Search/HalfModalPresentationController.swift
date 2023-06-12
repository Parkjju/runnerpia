//
//  HalfModalPresentationController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/02.
//

import UIKit
import SnapKit
import NMapsMap

class HalfModalPresentationController: UIViewController {
    
    // MARK: - Properties
    
    var halfModalView = HalfModalView()
    var searchView = SearchView()
    
    var data: Route?{
        didSet{
            configureUI()
            
            mergedTags[0] = data?.secureTags ?? []
            mergedTags[1] = data?.recommendedTags ?? []
            
            DispatchQueue.main.async {
                self.halfModalView.tagsCollectionView.reloadData()
                self.updateCollectionViewHeight()
            }
        }
    }
    var mergedTags: [[String]] = [[], []]
    // MARK: - LifeCycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegate()
    }
    
    override func loadView() {
      view = halfModalView
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.map.positionMode = .direction

        // updateLocation 
    }
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    
    private func configureUI() {
        halfModalView.backgroundColor = .white

        // ⚠️ 추후수정
        halfModalView.spotLabel.text = data?.routeName
        halfModalView.locationLabel.text = data?.location
        halfModalView.tagsCollectionView.allowsMultipleSelection = true
        if let distance = data?.distance {
            halfModalView.distanceLabel.text = "\(distance)km"
        } else {
            halfModalView.distanceLabel.text = ""
        }
        
    }
    
    private func configureDelegate() {
        halfModalView.tagsCollectionView.dataSource = self
        halfModalView.tagsCollectionView.delegate = self
    }
    
    func updateCollectionViewHeight(){
        // 안심태그 컬렉션뷰 dynamic height
        halfModalView.tagsCollectionView.setNeedsLayout()
        halfModalView.tagsCollectionView.layoutIfNeeded()
        
        if(halfModalView.tagsCollectionView.contentSize.height > halfModalView.tagsCollectionView.frame.height){
            halfModalView.tagsCollectionView.snp.updateConstraints {
                $0.height.equalTo(halfModalView.tagsCollectionView.contentSize.height)
            }
        }
    }
}



// MARK: - CollectionView

extension HalfModalPresentationController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mergedTags[0].count + mergedTags[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
        
        // MARK: 안전태그 / 추천태그 데이터 바인딩 로직 추가 필요
        if(indexPath.item < mergedTags[0].count){
            cell.isSecureTag = true
            cell.tagName = globalSecureTags[indexPath.item]
        }else{
            cell.isSecureTag = false
            cell.tagName = globalRecommendedTags[indexPath.item - mergedTags[0].count]
        }
        cell.isChecked = true
        
        return cell
    }
    
    
    
}
