//
//  AdditionalInfoLinkTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit

class AdditionalInfoLinkTableViewCell: UITableViewCell {
    
    static let identifier = "AdditionalInfoLinkTableViewCell"
    
    private let altLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = Fonts.listSubtitle
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(altLabel)
        contentView.addSubview(iconImageView)
        
        altLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configure(altText: String, linkUrlString: String, iconImage: UIImage) {
        altLabel.text = altText
        iconImageView.image = iconImage
        let tap = UrlGestureRecognizer(target: self, action: #selector(self.openLink(_:)))
        tap.urlString = linkUrlString
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func openLink(_ sender: UrlGestureRecognizer) {
        if let urlString = sender.urlString,
            let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

fileprivate class UrlGestureRecognizer: UITapGestureRecognizer {
    var urlString: String?
}
