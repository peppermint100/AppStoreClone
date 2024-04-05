//
//  AppDetailBigTableViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit
import Kingfisher

class AppDetailHeadImageTableViewCell: UITableViewCell {
    
    static let identifier = "AppDetailHeadImageTableViewCell"
    
    private let iv = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iv)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with urlString: String) {
        let url = URL(string: urlString)
        iv.kf.setImage(with: url)
    }
}
