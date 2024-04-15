//
//  SearchResultTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = appItemViewHeight + infoViewHeight + screenshotsViewHeight + extraSpace
    static let identifier = "SearchResultTableViewCell"
    
    private let appItemView = ItunesAppItemListView()
    
    private let infoView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.strongCaption
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.strongCaption
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let contentAdvisoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.strongCaption
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let screenshotsView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(appItemView)
        contentView.addSubview(infoView)
        contentView.addSubview(screenshotsView)
        
        infoView.addArrangedSubview(ratingLabel)
        infoView.addArrangedSubview(genreLabel)
        infoView.addArrangedSubview(contentAdvisoryLabel)
        
        appItemView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(appItemViewHeight)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(appItemView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(infoViewHeight)
        }
        
        screenshotsView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(screenshotsViewHeight)
        }
    }
        
    func configure(with app: ItunesApp) {
        appItemView.configure(with: app)
        configureInfoView(with: app)
        configureScreenshotView(with: app)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        screenshotsView.arrangedSubviews.forEach {
             screenshotsView.removeArrangedSubview($0)
             $0.removeFromSuperview()
        }
    }
}

private extension SearchResultTableViewCell {

    func configureInfoView(with app: ItunesApp) {
        ratingLabel.text = "\(app.averageRatingStar()) \(app.shortenRatingCount())"
        if let genreText = app.genres.first {
            genreLabel.text = genreText
        }
        contentAdvisoryLabel.text = app.contentAdvisoryRating
    }
    
    func configureScreenshotView(with app: ItunesApp) {
        let screenshotUrls = app.screenshotUrls.prefix(3)
        for screenshotUrl in screenshotUrls {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 0.2
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.kf.setImage(with: URL(string: screenshotUrl))
            screenshotsView.addArrangedSubview(imageView)
        }
    }
}

fileprivate let appItemViewHeight: CGFloat = 100
fileprivate let infoViewHeight: CGFloat = 30
fileprivate let screenshotsViewHeight: CGFloat = 300
fileprivate let extraSpace: CGFloat = 50
