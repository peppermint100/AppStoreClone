//
//  TodayBigCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit
import Kingfisher

class TodayBigCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayBigCollectionViewCell"
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.title
        label.numberOfLines = 2
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.caption
        return label
    }()
    
    private let bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let appItemView: ItunesAppItemView = {
        let view = ItunesAppItemView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(bgImageView)
        containerView.addArrangedSubview(appItemView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        appItemView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        bgImageView.addSubview(titleLabel)
        bgImageView.addSubview(captionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(captionLabel.snp.top)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        captionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with app: ItunesApp) {
        titleLabel.text = app.trackName
        captionLabel.text = app.artistName
        let url = URL(string: app.artworkUrl512)
        bgImageView.kf.indicatorType = .activity
        bgImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                guard let averageColor = value.image.averageColor else { return }
                self?.bgImageView.labelGradient()
                self?.appItemView.backgroundColor = averageColor.withAlphaComponent(0.5)
            case .failure(_):
                return
            }
        }
        
        appItemView.configure(with: app)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
