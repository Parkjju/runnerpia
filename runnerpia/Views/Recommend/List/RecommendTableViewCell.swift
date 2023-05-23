//
//  RecommendTableViewCell.swift
//  runnerpia
//
//  Created by Jun on 2023/05/22.
//

import UIKit
import NMapsMap

class RecommendTableViewCell: UITableViewCell {
    
    var cellData: Route?{
        didSet{
            setupUI()
        }
    }
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("작성글로 이동", for: .normal)
        btn.setTitleColor(UIColor.textGrey02, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 31일 토요일 오후 6-9시 - 500분 - 100km"
        label.textColor = UIColor.textGrey02
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let map: NMFMapView = {
        let map = NMFMapView()
        map.mapType = .basic
        map.positionMode = .direction
        map.layer.cornerRadius = 10
        return map
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        let text = NSMutableAttributedString(string: "두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .light, width: .standard), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = text
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    let tagBox: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 100
        sv.distribution = .fillProportionally
        sv.alignment = .fill
        sv.backgroundColor = .black
        return sv
    }()
    
    let recommendTag: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(){
        setContentView()
        setUIWithData()
    }
    
    func setContentView(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    func setUIWithData(){
        guard let data = cellData else {
            return
        }
        
        mainLabel.text = data.routeName
        infoLabel.text = "\(data.runningDate!) ﹒ \(data.runningTime!) ﹒ \(data.distance!)km"
        summaryLabel.text = "\(data.review!)"
        
        setMap(data)
        setTags(secureTags: data.secureTags!, recommendedTags: data.recommendedTags!)
    }
    
    func setMap(_ data: Route){
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: data.arrayOfPos!.first!.latitude, lng: data.arrayOfPos!.first!.longitude))
        map.moveCamera(cameraUpdate)
        map.minZoomLevel = 10
        map.maxZoomLevel = 20
        
        let pathOverlay = NMFPath()
        let points:[NMGLatLng] = data.arrayOfPos!.map {NMGLatLng(from:$0)}
        pathOverlay.path = NMGLineString(points: points)
        pathOverlay.color = .polylineColor
        pathOverlay.outlineColor = .clear
        pathOverlay.width = 10
        pathOverlay.mapView = map
    }
    
    func setTags(secureTags: [String], recommendedTags: [String]){
        let secureTagBox = secureTags.map {
            let tag = Tag()
            tag.isSecureTag = true
            tag.tagName = globalSecureTags[Int($0)!]
            return tag
        }
        
        let recommendedTagBox = recommendedTags.map{
            let tag = Tag()
            tag.isSecureTag = false
            tag.tagName = globalRecommendedTags[Int($0)!]
            return tag
        }
        
        let gradientTag = Tag()
        gradientTag.isGradient = true
        gradientTag.tagName = "+3"
        
        [secureTagBox.first!, recommendedTagBox.first!, gradientTag].forEach { tagBox.addSubview($0) }
    }
}

extension RecommendTableViewCell: LayoutProtocol{
    func setSubViews() {
        [mainLabel,button, infoLabel, map, summaryLabel, tagBox].forEach { self.contentView.addSubview($0) }
    }
    
    func setLayout() {
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(16)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.trailing.equalTo(button.snp.leading)
        }
        
        button.snp.makeConstraints {
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            $0.width.equalTo(76)
            $0.lastBaseline.equalTo(mainLabel.snp.lastBaseline)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(6)
            $0.leading.equalTo(mainLabel.snp.leading)
        }
        
        map.snp.makeConstraints {
            $0.leading.equalTo(mainLabel.snp.leading)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.height.equalTo(160)
        }
        
        summaryLabel.snp.makeConstraints {
            $0.leading.equalTo(mainLabel.snp.leading)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            $0.top.equalTo(map.snp.bottom).offset(10)
        }
        
        tagBox.snp.makeConstraints {
            $0.leading.equalTo(mainLabel.snp.leading)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            $0.top.equalTo(summaryLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
        }
    }
}
