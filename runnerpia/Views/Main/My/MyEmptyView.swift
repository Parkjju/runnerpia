//
//  EmptyRecommendView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//

import UIKit

final class MyEmptyView: UIView {
    
    // MARK: - Properties
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .semiBold18
        return label
    }()
    
    lazy var connectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue400
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        var config = UIButton.Configuration.plain()
        config.titlePadding = 16
        button.configuration = config
        
        let attributedTitle = NSAttributedString(string: "추천 경로 보러가기", attributes: [
            NSAttributedString.Key.font: UIFont.semiBold16,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)

        return button
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

    }
}


// MARK: - Layouts

extension MyEmptyView: LayoutProtocol {
    
    func setSubViews() {
        [ commentLabel, connectButton ].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        
        commentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(connectButton.snp.top).offset(-16)
        }
        
        connectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(16).priority(.high)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16).priority(.high)
            $0.height.equalTo(48)
        }
    }
    
}
