//
//  TodayCardView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/17/24.
//

import UIKit
import SnapKit
import Kingfisher

class TodayCardView: UIView {
    
    var image: UIImage?
    var title: String?
    var cardType: CardType = .cell
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.title
        label.numberOfLines = 2
        return label
    }()
        
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(imageUrlString: String, title: String) {
        let imageUrl = URL(string: imageUrlString)
        imageView.kf.setImage(with: imageUrl)
        titleLabel.text = title
        updateLayout(for: cardType)
    }
    
    func retriveImage() -> UIImage? {
        return imageView.image
    }
}

extension TodayCardView {
    convenience init(image: UIImage, title: String, cardType: CardType) {
        self.init(frame: .zero)
        self.image = image
        self.title = title
        self.cardType = cardType
        setupUI()
    }
    
    convenience init(cardType: CardType) {
        self.init(frame: .zero)
        self.cardType = cardType
        setupUI()
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        updateLayout(for: cardType)
    }
    
    private func updateLayout(for cardType: CardType) {
        if cardType == .cell {
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(TodayViewController.SizeConstant.bigCellImageHeight)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        } else {
            titleLabel.isHidden = true
            
            imageView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(TodayViewController.SizeConstant.bigCellImageHeight + 100)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
}
