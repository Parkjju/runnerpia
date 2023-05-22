//
//  RecommendView.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit

class RecommendView: UIView {
    // MARK: Properties
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
        
        // 하드코딩함수 - 나중에 지울 예정!
        setupData()
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
    }
    
    private func setupData(){
        let firstData = Route(user: User(userId: "경준", nickname: "경준"), routeName: "한강 잠실 러닝길" , arrayOfPos: nil, runningTime: "500분", review: "두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.", runningDate: "2023-12-30", recommendedTags: ["1","2"], secureTags: ["0","1","2"], files: nil)
        let secondData = Route(user: User(userId: "경준", nickname: "경준"),routeName: "한강 잠실 러닝길", arrayOfPos: nil, runningTime: "320분", review: "예시 데이터입니다. 여기 러닝 코스 아주 괜찮습니다. 붕어빵 가게도 있습니다. 중간에 ㅕ편의점도 있어요 ! 경치가 좋아요~ 고양이가 많습니당", runningDate: "2023-02-20", recommendedTags: ["1","2","3"], secureTags: ["1","2"], files: nil)
        
        
        routeData.append(firstData)
        routeData.append(secondData)
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
            $0.bottom.equalToSuperview()
        }
    }
}

extension RecommendView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
}

extension RecommendView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendCell", for: indexPath) as! RecommendTableViewCell
        
        cell.cellData = routeData.count > 0 ? routeData[indexPath.row] : nil
        
        return cell
    }
}
