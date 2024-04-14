//
//  CategoryAppItemCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/14/24.
//

import UIKit
import SnapKit

class CategoryAppItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryAppItemCollectionViewCell"
    
    private let appItemView = ItunesAppItemListView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(appItemView)
        
        appItemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with app: ItunesApp) {
        appItemView.configure(with: app)
    }
}
