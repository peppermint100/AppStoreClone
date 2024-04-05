//
//  AdditionalInfoNameAndValueTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit

class AdditionalInfoNameAndValueTableViewCell: UITableViewCell {
    
    static let identifier = "AdditionalInfoNameAndValueTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = Fonts.listSubtitle
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Fonts.listSubtitle
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configure(name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
