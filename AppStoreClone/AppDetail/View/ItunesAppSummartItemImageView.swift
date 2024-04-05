//
//  ItunesAppSummaryItemView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/3/24.
//

import UIKit
import SnapKit

class ItunesAppSummaryItemImageView: UIView {
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 4
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.footnote
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.caption
        label.textColor = .secondaryLabel
        return label
    }()
    
    let divider = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        addSubview(divider)
        
        divider.backgroundColor = .systemGray4
        
        divider.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
        }
        
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(valueImage)
        containerView.addArrangedSubview(subtitleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String, subtitle: String, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        valueImage.image = image
    }
}
