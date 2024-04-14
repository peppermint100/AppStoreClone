//
//  GradientHeaderCollectionReusableView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/14/24.
//

import UIKit

class GradientHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "GradientHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
