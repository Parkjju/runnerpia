//
//  PhotoViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/23.
//

import UIKit
import SnapKit

final class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    var photoView = PhotoView()
    let pageControl = UIPageControl()
    let particularRouteController = ParticularRouteController()
    
    //  ⚠️ 추후 수정
    var data: Route?

                  
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        addContentScrollView()
        setPageControl()
        updateNavigationBarTitle()
        configureDelegate()
    }
    
    override func loadView() {
        view = photoView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addContentScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPageControlSelectedPage(currentPage: pageControl.currentPage)
        updateNavigationBarTitle()
    }


    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.white ]
        if let backButtonImage = UIImage(systemName: "chevron.backward") {
            let leftBarButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = leftBarButton
        }
    }
    
    private func configureDelegate() {
        photoView.scrollView.delegate = self
    }
    
    private func addContentScrollView() {
//        let data = particularRouteController.setupData()
        
        let files = data?.files ?? []
        
        for i in 0..<files.count {
            let imageView = UIImageView()

            imageView.contentMode = .scaleAspectFit
            let xPos = photoView.scrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: photoView.scrollView.frame.width, height: photoView.scrollView.frame.height)
            imageView.image = files[i]
            photoView.scrollView.addSubview(imageView)
            photoView.scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    
    }

    // 페이지 갯수
    private func setPageControl() {
        if let filesCount = data?.files?.count {
            let currentIndex = min(pageControl.currentPage, filesCount - 1)
            pageControl.currentPage = currentIndex
        } else {
            pageControl.currentPage = 0
        }
     }
    
    // 현재 선택된 페이지
    private func setPageControlSelectedPage(currentPage:Int) {
        guard let filesCount = data?.files?.count else {
            pageControl.numberOfPages = 0
            return
        }
        pageControl.numberOfPages = filesCount
      }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let contentOffsetX = scrollView.contentOffset.x
        let currentPage: Int
        
        if pageWidth > 0 {
            currentPage = Int((contentOffsetX + pageWidth / 2) / pageWidth)
        } else {
            currentPage = 0
        }
        
        pageControl.currentPage = currentPage
        updateNavigationBarTitle()
    }
    
    private func updateNavigationBarTitle() {
        let imageCount = pageControl.numberOfPages
        let currentPage = pageControl.currentPage
        let title = "\(currentPage + 1)/\(imageCount)"
        navigationItem.title = title
    }

}
    
