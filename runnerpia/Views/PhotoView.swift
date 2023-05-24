//
//  PhotoView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/23.
//
import UIKit

final class PhotoView: UIView {
    
    // MARK: - Properties

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    var images: [UIImage] = [] {
        didSet {
            setupImageViews()
        }
    }
    
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureUI()
        setSubViews()
        setLayout()
        setupImageViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = .black
        
    }
    
    func setupImageViews() {
        
        scrollView.subviews.forEach { $0.removeFromSuperview() } // 기존의 이미지 뷰들을 제거합니다.

        scrollView.contentSize = CGSize(width: frame.width * CGFloat(images.count), height: frame.height)
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: CGFloat(index) * frame.width, y: 0, width: frame.width, height: frame.height)
            scrollView.addSubview(imageView)
        }
    }
}


// MARK: - Layouts

extension PhotoView: LayoutProtocol {
    
    func setSubViews() {
        addSubview(scrollView)
    }
    
    func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

}
