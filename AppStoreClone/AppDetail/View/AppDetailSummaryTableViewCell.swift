//
//  AppDetailSummaryTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit

class AppDetailSummaryTableViewCell: UITableViewCell {
    
    static let identifier = "AppDetailSummaryTableViewCell"
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 5
        return sv
    }()
    
    private let ratingItemView = ItunesAppSummaryItemView()
    private let advisoryItemView = ItunesAppSummaryItemView()
    private let developerItemView = ItunesAppSummaryItemImageView()
    private let languageItemView = ItunesAppSummaryItemView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-20)
        }
        
        containerView.addArrangedSubview(ratingItemView)
        containerView.addArrangedSubview(advisoryItemView)
        containerView.addArrangedSubview(developerItemView)
        containerView.addArrangedSubview(languageItemView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(summaries: [AppSummary]) {
        guard
            let ratingSummary = summaries[0] as? AppSummaryString,
            let advisorySummary = summaries[1] as? AppSummaryString,
            let developerSummary = summaries[2] as? AppSummaryImage,
            let languageSummary = summaries[3] as? AppSummaryString
        else{ return }
        
        let developerImage = developerSummary.value.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        
        ratingItemView.configure(title: ratingSummary.title, subtitle: ratingSummary.subtitle, value: ratingSummary.value)
        advisoryItemView.configure(title: advisorySummary.title, subtitle: advisorySummary.subtitle, value: advisorySummary.value)
        developerItemView.configure(title: developerSummary.title, subtitle: developerSummary.subtitle, image: developerImage)
        languageItemView.configure(title: languageSummary.title, subtitle: languageSummary.subtitle, value: languageSummary.value)
    }
}
