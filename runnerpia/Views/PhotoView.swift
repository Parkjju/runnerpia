//
//  PhotoView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/23.
//
import UIKit

final class PhotoView: UIView {
    
    // MARK: - Properties
    
    private lazy var routeImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
        addSubview(routeImage)
    }
    
    func setLayout() {
        routeImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(50)
        }

    }

}
