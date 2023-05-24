//
//  PhotoView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/23.
//
import UIKit

protocol PhotoViewDelegate: AnyObject {
    func photoViewDidUpdateImages(photoView: PhotoView)
}

final class PhotoView: UIView {
    
    weak var delegate: PhotoViewDelegate?
    
    // MARK: - Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureUI()
        setSubViews()
        setLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = .black
        
    }


}


// MARK: - Layouts

extension PhotoView: LayoutProtocol {
    
    func setSubViews() {
        addSubview(scrollView)
    }
    
    func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-50)
        }

    }

}
