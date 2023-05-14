//
//  HomeView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/05/14.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    // MARK: - Properties
    
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var mainFirstLabel: UILabel = {
        let label = UILabel()
        label.text = "어디로 달려야할지 모르겠다구요?"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var mainSecondLabel: UILabel = {
        let label = UILabel()
        label.text = "에디터분들의 러닝 기록을 따라가보세요!"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var mainLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainFirstLabel, mainSecondLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let recodeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "recodeButton"), for: .normal)
        return button
    }()
    
    private lazy var captionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(captionButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var exclamationMarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "exclamationMark")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var captionFirstLabel: UILabel = {
        let label = UILabel()
        label.text = "밤 늦게 러닝, 그동안 무서우셨죠?"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var captionSecondLabel: UILabel = {
        let label = UILabel()
        label.text = "러너피아에는 안심 태그가 있어요!"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var captionLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [captionFirstLabel, captionSecondLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nextButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nextButton")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Selectors
    @objc private func captionButtonTapped(_ sender: UIButton) {
        print("captionButton Tapped")
    }

    
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
        backgroundColor = .mainViewGrey
    }
    
    
}


// MARK: - Layouts

extension HomeView: LayoutProtocol {
    
    func setSubViews() {
        [mainImage, mainLabelStackView, recodeButton, exclamationMarkImage, captionLabelStackView, nextButton, captionButton]
            .forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        mainImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(109)
            $0.top.equalTo(self.snp.top).offset(130)
        }
        
        mainLabelStackView.snp.makeConstraints {
            $0.centerX.equalTo(mainImage.snp.centerX)
            $0.top.equalTo(mainImage.snp.top).offset(35)
            $0.leading.equalTo(mainImage.snp.leading).offset(20)
        }
        
        recodeButton.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(364)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainImage.snp.bottom).offset(19.03)
        }
        
        captionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(78)
            $0.top.equalTo(recodeButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        exclamationMarkImage.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(18)
            $0.leading.equalTo(captionButton.snp.leading).offset(20)
            $0.top.equalTo(captionButton.snp.top).offset(30)
        }

        captionLabelStackView.snp.makeConstraints {
            $0.centerX.equalTo(captionButton.snp.centerX)
            $0.top.equalTo(captionButton.snp.top).offset(18)
            $0.leading.equalTo(captionButton.snp.leading).offset(50)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        nextButton.snp.makeConstraints {
            $0.width.equalTo(6)
            $0.height.equalTo(11)
            $0.trailing.equalTo(captionButton.snp.trailing).offset(-23.5)
            $0.top.equalTo(captionButton.snp.top).offset(30)
        }
        
        captionButton.layer.zPosition = CGFloat(-1)
        
    }
}
