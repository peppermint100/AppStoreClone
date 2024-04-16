//
//  SearchRecommendedAppCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit

class SearchRecommendedAppCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchRecommendedAppCollectionViewCell"
    
    private let itemView = ItunesAppItemListView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemView)
        
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with app: ItunesApp) {
        itemView.configure(with: app)
    }
}
