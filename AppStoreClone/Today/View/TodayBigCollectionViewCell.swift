//
//  TodayBigCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import UIKit
import Kingfisher

class TodayBigCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayBigCollectionViewCell"
    
    var cardView: TodayCardView? {
        didSet {
            guard let cardView = cardView else { return }
            contentView.addSubview(cardView)
            
            cardView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(TodayViewController.SizeConstant.bigCellImageHeight)
            }
            
            cardView.layer.cornerRadius = 20
            cardView.clipsToBounds = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
