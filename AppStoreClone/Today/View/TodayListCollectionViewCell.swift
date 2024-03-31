//
//  TodayListCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit
import SnapKit

class TodayListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayListCollectionViewCell"
    
    private let itemView = ItunesAppItemView()
    
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
