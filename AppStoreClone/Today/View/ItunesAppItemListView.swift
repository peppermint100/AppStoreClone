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
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(appIconImageView)
        addSubview(labelStackView)
        addSubview(openButton)
        addSubview(divider)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        
        appIconImageView.layer.cornerRadius = 12
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.borderWidth = 0.5
        appIconImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        openButton.layer.cornerRadius = 17
        openButton.clipsToBounds = true
        
        appIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(iconSize)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(openButton.snp.leading)
        }
        
        openButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(35)
        }
        
        divider.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            make.top.equalTo(appIconImageView.snp.bottom)
            make.height.equalTo(0.2)
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

fileprivate let iconSize: CGFloat = 75
