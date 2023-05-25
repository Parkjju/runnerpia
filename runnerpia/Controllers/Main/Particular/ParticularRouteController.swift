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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = particularView.routeButton.frame.height / 2
        particularView.routeButton.layer.masksToBounds = true
        particularView.routeButton.layer.cornerRadius = cornerRadius
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
    }
    
    private func configureNavigation() {
    }
    
    private func configureDelegate() {
        particularView.delegate = self
        particularView.collectionView.dataSource = self
        particularView.collectionView.delegate = self
        particularView.collectionView.register(ParticularCollectionViewCell.self, forCellWithReuseIdentifier: ParticularCollectionViewCell.identifier)
    }
    
}


// MARK: - CollectionView

extension ParticularRouteController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPhotosToShow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticularCollectionViewCell.identifier, for: indexPath) as? ParticularCollectionViewCell else { return UICollectionViewCell() }
        
        let image = UIImage(named: "random1")
        cell.imageView.image = image
        
        if indexPath.item == numberOfPhotosToShow - 1 && numberOfPhotosToShow >= 3 {
            cell.imageView.alpha = 0.5 // 불투명 효과 적용
            cell.numberLabel.text = "+\(numberOfPhotosToShow)" // 텍스트 설정
            cell.numberLabel.isHidden = false // 숫자 레이블 표시
        } else {
            cell.imageView.alpha = 1.0 // 불투명 효과 해제
            cell.numberLabel.isHidden = true // 숫자 레이블 숨김
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = UINavigationController(rootViewController: PhotoViewController())
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
        
    }
    
    
}

extension ParticularRouteController: UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // 원하는 가로 간격 값으로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // 원하는 세로 간격 값으로 설정
    }
    
}



// MARK: - Delegate

extension ParticularRouteController: ParticularViewDelegate {
    
    func bookmarkButtonTapped(_ particularView: ParticularView) {
        if particularView.bookmarkButton.isSelected {
            particularView.bookmarkButton.isSelected = false
            // 북마크 제거에 관련된 추가 로직을 수행합니다.
        } else {
            // 선택되지 않은 상태인 경우 북마크를 추가합니다.
            let alertController = UIAlertController(title: "북마크에 저장했어요", message: "마이 > 북마크로 이동하면, 저장한 경로들을 모아서 볼 수 있어요.", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                particularView.bookmarkButton.isSelected = true
                // 북마크 추가에 관련된 추가 로직을 수행합니다.
            }
            
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func routeButtonTapped(_ particularView: ParticularView) {
        print("경로 따라가기 버튼 탭")
    }
    
}

