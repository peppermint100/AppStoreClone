//
//  TodayNavigationTitleView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit
import SnapKit

class TodayNavigationTitleView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String, subtitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
}
