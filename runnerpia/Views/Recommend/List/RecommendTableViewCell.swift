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
        
        let text = NSMutableAttributedString(string: "두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = text
        label.numberOfLines = 0
        
        return label
    }()
    
    let tagBox: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
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
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        guard let data = cellData else {
            return
        }
        
        mainLabel.text = data.routeName
        infoLabel.text = "\(data.runningDate!) ﹒ \(data.runningTime!) ﹒ \(data.distance!)km"
    }
}

extension RecommendTableViewCell: LayoutProtocol{
    func setSubViews() {
        [mainLabel,button, infoLabel].forEach { self.contentView.addSubview($0) }
    }
    
    func setLayout() {
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(16)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
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
    }
}
