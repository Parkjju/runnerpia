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
        
        // 첫 번째 라벨 (상단)
        let titleLabel = UILabel()
        titleLabel.text = "추천 경로 등록 내역"
        titleLabel.font = .semiBold18
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        // 두 번째 라벨 (하단)
        let subtitleLabel = UILabel()
        subtitleLabel.text = "총 124회의 러닝 경로 기록으로 \n 데일리 마라토너 뱃지를 얻었어요"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .regular14
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .left
        
        // 아이콘 이미지뷰
        let iconImageView = UIImageView()
        let iconImage = UIImage(named: "rightArrow")
        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        
        button.addSubview(titleLabel)
        button.addSubview(subtitleLabel)
        button.addSubview(iconImageView)
        
        // 오토레이아웃 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
        }

        iconImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-18)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }

        // 버튼 크기 조정
        button.sizeToFit()

//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // --- 3. 버튼들
    
    private lazy var runningRecodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.grey500.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        
        // 이미지뷰 (왼쪽 이미지)
        let leftImageView = UIImageView()
        let leftImage = UIImage(named: "mapIcon")
        leftImageView.image = leftImage
        leftImageView.contentMode = .scaleAspectFit
        
        
        // 이미지뷰 (오른쪽 이미지)
        let rightImageView = UIImageView()
        let rightImage = UIImage(named: "nextButton")
        rightImageView.image = rightImage
        rightImageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = "러닝 기록 내역"
        label.font = .semiBold14
        label.textColor = .black
        label.textAlignment = .left
        
        button.addSubview(leftImageView)
        button.addSubview(rightImageView)
        button.addSubview(label)
        
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(leftImageView.snp.centerY)
            $0.leading.equalTo(leftImageView.snp.trailing).offset(12)
        }

        rightImageView.snp.makeConstraints {
            $0.centerY.equalTo(label.snp.centerY)
            $0.trailing.equalToSuperview().offset(-23)
        }

        // 버튼 크기 조정
        button.sizeToFit()
        
//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var reviewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.grey500.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3
        
        // 이미지뷰 (왼쪽 이미지)
        let leftImageView = UIImageView()
        let leftImage = UIImage(named: "reviewIcon")
        leftImageView.image = leftImage
        leftImageView.contentMode = .scaleAspectFit
        
        
        // 이미지뷰 (오른쪽 이미지)
        let rightImageView = UIImageView()
        let rightImage = UIImage(named: "nextButton")
        rightImageView.image = rightImage
        rightImageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = "작성한 리뷰"
        label.font = .semiBold14
        label.textColor = .black
        label.textAlignment = .left
        
        button.addSubview(leftImageView)
        button.addSubview(rightImageView)
        button.addSubview(label)
        
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(leftImageView.snp.centerY)
            $0.leading.equalTo(leftImageView.snp.trailing).offset(12)
        }

        rightImageView.snp.makeConstraints {
            $0.centerY.equalTo(label.snp.centerY)
            $0.trailing.equalToSuperview().offset(-23)
        }

        // 버튼 크기 조정
        button.sizeToFit()
        
//        button.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // --- 4. 로그아웃
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.grey500, for: .normal)
        button.titleLabel?.font = .regular14
        let iconImage = UIImage(named: "logoutButton")
        button.setImage(iconImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
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
            $0.top.equalTo(recommendButton.snp.bottom).offset(10)
            $0.leading.equalTo(recommendButton.snp.leading)
            $0.trailing.equalTo(recommendButton.snp.trailing)
            $0.height.equalTo(58)
        }
        
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(runningRecodeButton.snp.bottom).offset(10)
            $0.leading.equalTo(runningRecodeButton.snp.leading)
            $0.trailing.equalTo(runningRecodeButton.snp.trailing)
            $0.height.equalTo(58)
        }
        
        logoutButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(50)
        }
        
    }
    
    
    
}
