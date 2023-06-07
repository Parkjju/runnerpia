//
//  MyRunningView.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//

import UIKit

final class MyRunningView: UIView {
    
    // MARK: - Properties
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "총 n개"
        label.font = .semiBold14
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
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
        backgroundColor = .white
 
    }
}


// MARK: - Layouts

extension MyRunningView: LayoutProtocol {
    
    func setSubViews() {

        [ commentLabel, tableView ]
            .forEach { self.addSubview($0) }

    }
    
    func setLayout() {
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-14)
            
        }
        
    }
    
}
