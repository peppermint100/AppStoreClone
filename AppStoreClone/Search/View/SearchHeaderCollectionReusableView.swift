//
//  SearchHeaderCollectionReusableView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit
import SnapKit

class SearchHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "SearchHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.headerTitle
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
