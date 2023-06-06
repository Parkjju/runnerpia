//
//  MyPageView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/06.
//

import UIKit

final class MyPageView: UIView {
    
    // MARK: - Properties
    
    // --- 1. 프로필 스택뷰
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "profileImage")!.scalePreservingAspectRatio(targetSize: CGSize(width: 90, height: 90))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .semiBold24
        label.text = "달리는 다람쥐"
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .regular14
        label.text = "runningmap@naver.com"
        return label
    }()
    
    lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImage, nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // --- 2. 추천경로등록내역
    
    private lazy var recommendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue200
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // --- 3. 버튼들
    
    private lazy var runningRecodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var reviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // --- 4. 로그아웃
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = .regular14
//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
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
        backgroundColor = .grey100
    }
}


// MARK: - Layouts

extension MyPageView: LayoutProtocol {
    
    func setSubViews() {
        [profileStackView, recommendButton, runningRecodeButton, reviewButton, logoutButton]
            .forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
        }
        
        recommendButton.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(25)
            $0.leading.equalTo(profileStackView.snp.leading)
            $0.trailing.equalTo(profileStackView.snp.trailing)
            $0.height.equalTo(106)
        }
        
        runningRecodeButton.snp.makeConstraints {
            $0.top.equalTo(recommendButton.snp.bottom).offset(25)
            $0.leading.equalTo(recommendButton.snp.leading)
            $0.trailing.equalTo(recommendButton.snp.trailing)
        }
        
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(runningRecodeButton.snp.bottom).offset(25)
            $0.leading.equalTo(runningRecodeButton.snp.leading)
            $0.trailing.equalTo(runningRecodeButton.snp.trailing)
        }
        
        logoutButton.snp.makeConstraints {
            // ⭐️ 수정
            $0.bottom.equalToSuperview().offset(30)
            $0.leading.equalTo(reviewButton.snp.leading)
            $0.trailing.equalTo(reviewButton.snp.trailing)
        }
        
    }
    
    
    
}
