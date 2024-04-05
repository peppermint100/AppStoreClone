//
//  AppDetailDescTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/5/24.
//

import UIKit
import SnapKit

class AppDetailDescTableViewCell: UITableViewCell {
    
    static let identifier = "AppDetailDescTableViewCell"
    
    var didTapMoreButtonClosure: (() -> Void)?
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        return label
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("펼치기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descLabel)
        contentView.addSubview(buttonView)
        
        buttonView.addSubview(moreButton)
        
        descLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(buttonView.snp.top)
        }
        
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(30)
        }
        
        moreButton.addTarget(self, action: #selector(expand), for: .touchUpInside)
    }
    
    @objc private func expand() {
        descLabel.numberOfLines = 0
        moreButton.isHidden = true
        didTapMoreButtonClosure?()
    }
    
    func configure(desc: String) {
        descLabel.text = desc
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
