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
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
    }

    private func setupData(){
        let firstData = Route(user: User(userId: "경준", nickname: "경준"), routeName: "한강 잠실 러닝길한강 잠실 러닝길한강 잠실 러닝길" ,distance: 500, arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)], location:"성동구 송정동" , runningTime: "500분", review: "두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.", runningDate: "12월 31일 토요일 오후 6~9시", recommendedTags: ["1","2"], secureTags: ["0","1","2"], files: nil)
        let secondData = Route(user: User(userId: "경준", nickname: "경준"),routeName: "한강 잠실 러닝길",distance: 300,arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2759, longitude: 127.1488), CLLocationCoordinate2D(latitude: 37.2765, longitude: 127.1493), CLLocationCoordinate2D(latitude: 37.2771, longitude: 127.1502)], location:"기흥구 동백동" , runningTime: "320분", review: "예시 데이터입니다. 여기 러닝 코스 아주 괜찮습니다. 붕어빵 가게도 있습니다. 중간에 ㅕ편의점도 있어요 ! 경치가 좋아요~ 고양이가 많습니당", runningDate: "12월 30일 일요일 오후 2~3시", recommendedTags: ["0","1","2"], secureTags: ["0","1"], files: nil)
        
        let thirdData = Route(user: User(userId: "경준", nickname: "경준"),routeName: "동백 호수공원",distance: 200,arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)], location:"기흥구 언동로" , runningTime: "200분", review: "나무가 풍성한 동백 호수공원을 달려보아요", runningDate: "12월 30일 일요일 오후 2~3시", recommendedTags: ["0","1","2"], secureTags: ["0","1", "2", "3", "4"], files:[UIImage(named: "test1")!, UIImage(named:"test2")!, UIImage(named:"test3")!, UIImage(named:"test4")!])
        
        
        routeData.append(firstData)
        routeData.append(secondData)
        routeData.append(thirdData)
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
