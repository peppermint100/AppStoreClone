//
//  ItunesAppItemView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit
import Kingfisher

class ItunesAppItemListView: UIView {
    
    private let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let labelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    private let openButton = OpenAppButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(appIconImageView)
        addSubview(labelStackView)
        addSubview(openButton)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        
        appIconImageView.layer.cornerRadius = 12
        appIconImageView.clipsToBounds = true
        
        openButton.layer.cornerRadius = 20
        openButton.clipsToBounds = true
        
        appIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(snp.height).multipliedBy(0.8)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(openButton.snp.leading)
        }
        
        openButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with app: ItunesApp) {
        titleLabel.text = app.trackName
        subtitleLabel.text = app.artistName
        let url = URL(string: app.artworkUrl100)
        appIconImageView.kf.setImage(with: url)
        openButton.configure(trackId: app.trackID)
    }
}
