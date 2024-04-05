//
//  AppDetailLaunchableTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit
import Kingfisher

class AppDetailLaunchableTableViewCell: UITableViewCell {
    
    static let identifier = "AppDetailLaunchableTableViewCell"
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    private let iconImageContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let labelContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Fonts.appDetailTitle
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = Fonts.appDetailSubtitle
        return label
    }()
    
    private let openButton = OpenAppButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupIcon()
        setupLabels()
    }
    
    private func setupIcon() {
        containerView.addArrangedSubview(iconImageContainer)
        
        iconImageContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.32)
        }
        
        iconImageContainer.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(105)
            make.center.equalToSuperview()
        }
        
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
    }
    
    private func setupLabels() {
        containerView.addArrangedSubview(labelContainerView)
        
        labelContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.68)
        }
        
        labelContainerView.addSubview(nameLabel)
        labelContainerView.addSubview(companyLabel)
        labelContainerView.addSubview(openButton)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(10)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
        
        openButton.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(iconUrlString: String, title: String, subtitle: String, trackId: Int) {
        let imageUrl = URL(string: iconUrlString)
        iconImageView.kf.setImage(with: imageUrl)
        nameLabel.text = title
        companyLabel.text = subtitle
        openButton.configure(trackId: trackId)
    }
}

