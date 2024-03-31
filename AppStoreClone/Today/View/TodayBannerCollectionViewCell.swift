//
//  TodayBannerCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit
import Kingfisher

class TodayBannerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayBannerCollectionViewCell"
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    private let appIconContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let appInfoView: UIView = {
        let view = UIView()
        view.shadow()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.listTitle
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = Fonts.listSubtitle
        return label
    }()
    
    private let openButton = OpenAppButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemYellow
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        appIconContainerView.shadow()
        
        contentView.addSubview(containerView)
        
        containerView.addArrangedSubview(appIconContainerView)
        containerView.addArrangedSubview(appInfoView)
        
        appIconContainerView.addSubview(appIconImageView)
        
        appInfoView.addSubview(titleLabel)
        appInfoView.addSubview(subtitleLabel)
        appInfoView.addSubview(openButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        appIconImageView.layer.cornerRadius = 20
        appIconImageView.clipsToBounds = true
        
        appIconContainerView.snp.makeConstraints { make in
            make.width.equalTo(containerView.snp.height).multipliedBy(0.5)
            make.height.equalTo(containerView.snp.height).multipliedBy(0.5)
            make.top.equalToSuperview().offset(15)
        }
        
        appIconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        appInfoView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        openButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with app: ItunesApp) {
        titleLabel.text = app.trackName
        subtitleLabel.text = app.artistName
        let url = URL(string: app.artworkUrl100)
        appIconImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                self?.containerView.backgroundColor = value.image.averageColor?.withAlphaComponent(0.3)
                self?.appInfoView.labelGradient(.bottom, .soft)
            case .failure:
                return
            }
        }
        openButton.configure(trackId: app.trackID)
    }
}
