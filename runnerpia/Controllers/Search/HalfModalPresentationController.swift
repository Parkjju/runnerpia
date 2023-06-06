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
        let particularRouteController = ParticularRouteController()
        let data = particularRouteController.setupData()
        halfModalView.spotLabel.text = data.routeName
        if let distance = data.distance {
            halfModalView.distanceLabel.text = "\(distance)km"
        } else {
            halfModalView.distanceLabel.text = ""
        }
        
    }
    
    private func configureDelegate() {
        halfModalView.tagsCollectionView.dataSource = self
        halfModalView.tagsCollectionView.delegate = self
    }
}



// MARK: - CollectionView

extension HalfModalPresentationController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
        
        switch(indexPath.item) {
        case 0:
            cell.isSecureTag = true
            cell.tagName = globalSecureTags[indexPath.item]
        case 1:
            cell.isSecureTag = false
            cell.tagName = globalRecommendedTags[indexPath.item]
        case 2:
            cell.tagName = "+3"
            cell.isGradient = true
        default:
            break
        }
        
        return cell
    }
    
    
    
}
