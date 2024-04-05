//
//  ItunesAppDetailHeaderView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/1/24.
//

import UIKit
import SnapKit
import Kingfisher

class ItunesAppItemView: UIView {
    
    private let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.appDetailTitle
        label.textColor = .label
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.appDetailSubtitle
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let openButton = OpenAppButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(appIconImageView)
        addSubview(appNameLabel)
        addSubview(companyNameLabel)
        addSubview(openButton)
        
        appIconImageView.layer.cornerRadius = 20
        appIconImageView.clipsToBounds = true
        
        appIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(90)
            make.top.leading.equalToSuperview().offset(20)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(20)
        }
        
        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(20)
        }
        
        openButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.top.equalTo(companyNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(20)
        }
    }
    
    func configure(with app: ItunesApp) {
        let url = URL(string: app.artworkUrl512)
        appIconImageView.kf.setImage(with: url)
        appNameLabel.text = app.trackName
        companyNameLabel.text = app.artistName
        openButton.configure(trackId: app.trackID)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
