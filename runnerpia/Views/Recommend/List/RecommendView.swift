//
//  RecommendView.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit
import CoreLocation

class RecommendView: UIView {
    // MARK: Properties
    let imageCache = NSCache<NSString, UIImage>()
    var imageHashArray: [String] = []
    
    let mainLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        let text = NSMutableAttributedString(string: "러너피아만의 추천 경로로\n지금 달려볼까요?", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = text
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var routeData: [Route] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .white
        layer.backgroundColor = UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1).cgColor
        
        tableView.backgroundColor = UIColor.mainViewGrey
        
        tableView.register(RecommendTableViewCell.self, forCellReuseIdentifier: "recommendCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
    }


}
// MARK: - Layouts
extension RecommendView: LayoutProtocol{
    func setSubViews() {
        [mainLabel, tableView].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
}

extension RecommendView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let particularVC = ParticularRouteController()
        particularVC.data = routeData[indexPath.section]
        self.parentViewController?.navigationController?.pushViewController(particularVC, animated: false)
    }
}

extension RecommendView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return routeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendCell", for: indexPath) as! RecommendTableViewCell
    
        cell.cellData = routeData.count > 0 ? routeData[indexPath.section] : nil
        
        return cell
    }
}
