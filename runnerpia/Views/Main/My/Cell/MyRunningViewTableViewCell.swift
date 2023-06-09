//
//  MyRunningViewTableViewCell.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//

import UIKit
import NMapsMap

class MyRunningViewTableViewCell: UITableViewCell {
    
    var cellData: Route? {
        didSet {
            setData()
        }
    }

    // MARK: - Properties
    
    let map: NMFMapView = {
        let map = NMFMapView()
        map.allowsScrolling = false
        map.layer.cornerRadius = 10
        map.positionMode = .disabled
        return map
    }()
    
    // --- 1. 첫번쨰 스택뷰
    let routeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBold18
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .regular14
        label.textColor = .grey700
        return label
    }()
    
    lazy var firstStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [routeLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    // --- 2. 두번째 스택뷰
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .regular14
        label.textColor = .grey700
        return label
    }()
    
    // ---- 2-1. 가로스택뷰
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular14
        label.textColor = .grey700
        return label
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = .regular14
        label.textColor = .grey700
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular14
        label.textColor = .grey700
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [distanceLabel, lineLabel, timeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var secondStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, horizontalStackView])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    
    // --- 3. collectionView
    let tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Tag")
        
        return collectionView
    }()
    
    
    // MARK: - LifeCycles

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func setData() {
        guard let data = cellData else {
            return
        }
        
        routeLabel.text = data.routeName
        dateLabel.text = data.runningDate
        locationLabel.text = data.location
        
        if let distance = data.distance {
            let formattedDistance = String(format: "%.0f", distance)
            distanceLabel.text = "\(formattedDistance)km"
        } else {
            distanceLabel.text = nil
        }
        
        if let runningTime = data.runningTime {
            timeLabel.text = "\(runningTime)분"
        } else {
            timeLabel.text = nil
        }
    }
}


// MARK: - Layout

extension MyRunningViewTableViewCell: LayoutProtocol {
    
    func setSubViews() {
        [ map, firstStackView, secondStackView, tagsCollectionView ]
            .forEach { self.addSubview($0) }
        
    }
    
    func setLayout() {

        map.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalTo(self.contentView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(Constraints.paddingLeftAndRight)
            $0.height.equalTo(136)
            $0.width.equalTo(80)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
        }

        firstStackView.snp.makeConstraints {
            $0.top.equalTo(map.snp.top)
            $0.leading.equalTo(map.snp.trailing).offset(10)
        }

        secondStackView.snp.makeConstraints {
            $0.top.equalTo(firstStackView.snp.bottom).offset(10)
            $0.leading.equalTo(firstStackView.snp.leading)
        }

        tagsCollectionView.snp.makeConstraints {
            $0.top.equalTo(secondStackView.snp.bottom).offset(10)
            $0.leading.equalTo(secondStackView.snp.leading)
            $0.trailing.equalToSuperview().offset(-Constraints.paddingLeftAndRight)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
            $0.height.equalTo(30)
        }
    }
}

extension MyRunningViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
        
        switch(indexPath.item){
        case 0:
            cell.isSecureTag = true
            cell.tagName = globalSecureTags[indexPath.item]
            cell.isChecked = true
        case 1:
            cell.isSecureTag = false
            cell.tagName = globalRecommendedTags[indexPath.item]
            cell.isChecked = true
        case 2:
            cell.tagName = "+3"
            cell.isGradient = true
            cell.isChecked = true
        default:
            break
        }
    
        return cell
    }
}
