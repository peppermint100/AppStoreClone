//
//  TodayHeaderCollectionReusableView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit
import SnapKit

class TodayHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "TodayHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.subtitle
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(subtitleLabel.snp.bottom)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
