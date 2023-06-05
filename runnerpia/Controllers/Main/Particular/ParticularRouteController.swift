//
//  ParticularRouteController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/22.
//


import UIKit
import SnapKit
import CoreLocation
import NMapsMap

final class ParticularRouteController: UIViewController {
    
    
    // MARK: - Properties
    private var particularView = ParticularView()
    var data: Route?{
        didSet{
            configureUI()
            mergedTags[0] = data?.secureTags ?? []
            mergedTags[1] = data?.recommendedTags ?? []
            
            DispatchQueue.main.async {
                self.particularView.tagsCollectionView.reloadData()
                self.updateCollectionViewHeight()
            }
        }
    }
    var mergedTags: [[String]] = [[], []]
    
    // 추후 수정
    private let numberOfPhotosToShow = 3
    var selectedImage: UIImage?
    
    
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
        particularView.collectionView.tag = 1
        particularView.tagsCollectionView.tag = 2
        
        // ⚠️ 추후 수정
        guard let data = data else { return }
        particularView.spotLabel.text = data.routeName
        particularView.locationLabel.text = data.location
        if let distance = data.distance {
            particularView.distanceLabel.text = "\(distance)km"
        } else {
            particularView.distanceLabel.text = ""
        }
        particularView.textView.text = data.review
        
        guard let _ = data.files else {
            particularView.collectionView.isHidden = true
            particularView.collectionView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            return
        }
        
        
        setupMap()
    }
    
    func setupMap(){
        let pathOverlay = NMFPath()
        let points = data!.arrayOfPos!.map { location in
            NMGLatLng(lat: location.latitude, lng: location.longitude)
        }
        let cameraUpdate = NMFCameraUpdate(scrollTo: points.first!)
        pathOverlay.path = NMGLineString(points: points)
        pathOverlay.mapView = particularView.map
        pathOverlay.color = .polylineColor
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 10
        particularView.map.moveCamera(cameraUpdate)
    }
    
    private func configureNavigation() {
    }
    
    private func configureDelegate() {
        particularView.delegate = self
        particularView.collectionView.dataSource = self
        particularView.collectionView.delegate = self
        particularView.collectionView.register(ParticularCollectionViewCell.self, forCellWithReuseIdentifier: ParticularCollectionViewCell.identifier)
        
        particularView.tagsCollectionView.dataSource = self
        particularView.tagsCollectionView.delegate = self
        
    }
    
    func updateCollectionViewHeight(){
        // 안심태그 컬렉션뷰 dynamic height
        particularView.tagsCollectionView.setNeedsLayout()
        particularView.tagsCollectionView.layoutIfNeeded()
        
        if(particularView.tagsCollectionView.contentSize.height > particularView.tagsCollectionView.frame.height){
            particularView.tagsCollectionView.snp.updateConstraints {
                $0.height.equalTo(particularView.tagsCollectionView.contentSize.height)
            }
        }
    }
    

    
}


// MARK: - CollectionView

extension ParticularRouteController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return 3
            
        } else if collectionView.tag == 2 {
            return mergedTags[0].count + mergedTags[1].count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticularCollectionViewCell.identifier, for: indexPath) as? ParticularCollectionViewCell else { return UICollectionViewCell() }
     
            cell.imageView.image = data?.files?[indexPath.item]
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.cornerRadius = 10
            
            if indexPath.item == numberOfPhotosToShow - 1 && numberOfPhotosToShow >= 3 {
                cell.imageView.alpha = 0.5 // 불투명 효과 적용
                
                if let count = data?.files?.count {
                    cell.numberLabel.text = "+\(count - 3)"
                } else {
                    cell.numberLabel.text = ""
                }

                cell.numberLabel.isHidden = false // 숫자 레이블 표시
            } else {
                cell.imageView.alpha = 1.0 // 불투명 효과 해제
                cell.numberLabel.isHidden = true // 숫자 레이블 숨김
            }
            
            return cell
            
            
        } else if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
            
            // MARK: 안전태그 / 추천태그 데이터 바인딩 로직 추가 필요
            if(indexPath.item < mergedTags[0].count){
                cell.isSecureTag = true
                cell.tagName = globalSecureTags[indexPath.item]
            }else{
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[indexPath.item - mergedTags[0].count]
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoVC = PhotoViewController()
        photoVC.data = data
        
        if collectionView.tag == 1 {
                    let viewController = UINavigationController(rootViewController: photoVC)
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
        }

    }
    
}

extension ParticularRouteController: UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            let width: CGFloat = (collectionView.frame.width / 3) - 7
            return CGSize(width: width, height: width)
        }
        return CGSize(width: 100, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 1 {
            return 1.0 // 원하는 가로 간격 값으로 설정
        }
        return 1.0 // 기본값
    }
   
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        if collectionView.tag == 1 {
//            return 1.0 // 원하는 세로 간격 값으로 설정
//        }else if(collectionView.tag == 2){
//            return 10
//        }
//
//        return 1.0
//    }
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
        
//        let routeViewController = RouteViewController()
//        routeViewController.modalPresentationStyle = .fullScreen
//        present(routeViewController, animated: true, completion: nil)

        let routeVC = RouteViewController()
        let view = routeVC.view as! RouteRecordView
        view.routeData = data
        let navigationVC = UINavigationController(rootViewController: routeVC)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true)
    }
    
    func locationButtonTapped(_ particularView: ParticularView) {
        print("로케이션 버튼")
    }
    
}
