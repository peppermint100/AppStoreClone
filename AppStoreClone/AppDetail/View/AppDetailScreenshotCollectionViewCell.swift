//
//  AppDetailScreenshotCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit
import SnapKit
import Kingfisher

class AppDetailScreenshotCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppDetailScreenshotCollectionViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    func configure(with urlString: String) {
        let url = URL(string: urlString)
        imageView.kf.setImage(with: url)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
