//
//  ParticularRouteController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/22.
//


import UIKit
import SnapKit

final class ParticularRouteController: UIViewController {

    
    // MARK: - Properties
    private var particularView = ParticularView()
    private let numberOfPhotosToShow = 3

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureDelegate()
        configureUI()
        

    }
    
    override func loadView() {
        view = particularView
        particularView.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigation() {
    }
    
    private func configureDelegate() {
        particularView.collectionView.dataSource = self
        particularView.collectionView.delegate = self
        particularView.collectionView.register(ParticularCollectionViewCell.self, forCellWithReuseIdentifier: ParticularCollectionViewCell.identifier)

    }
}


// MARK: - CollectionView

extension ParticularRouteController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPhotosToShow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticularCollectionViewCell.identifier, for: indexPath) as? ParticularCollectionViewCell else { return UICollectionViewCell() }
        
        let image = UIImage(named: "random1")
        cell.imageView.image = image
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 1.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // 원하는 가로 간격 값으로 설정
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // 원하는 세로 간격 값으로 설정
    }


    
}




