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
    var images = [#imageLiteral(resourceName: "random1"), #imageLiteral(resourceName: "random2"), #imageLiteral(resourceName: "random4")]
    var imageViews = [UIImageView]()
    let pageControl = UIPageControl()
                  
                  
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        addContentScrollView()
        setPageControl()
        updateNavigationBarTitle()
        
        photoView.scrollView.delegate = self
        

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
    
    private func addContentScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let xPos = photoView.scrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: photoView.scrollView.frame.width, height: photoView.scrollView.frame.height)
            imageView.image = images[i]
            imageViews.append(imageView)
            photoView.scrollView.addSubview(imageView)
            photoView.scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }

    // 페이지 갯수
    private func setPageControl() {
        pageControl.numberOfPages = images.count
     }
    
    // 현재 선택된 페이지
    private func setPageControlSelectedPage(currentPage:Int) {
          pageControl.currentPage = currentPage
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
        let imageCount = images.count
        let currentPage = pageControl.currentPage
        let title = "\(currentPage + 1)/\(imageCount)"
        navigationItem.title = title
    }

}
    
