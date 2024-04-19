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
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        if let image = image {
            iv.image = image
        }
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.title
        label.numberOfLines = 2
        if let title = title {
            label.text = title
        }
        return label
    }()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(imageUrlString: String, title: String) {
        self.title = title
        let imageUrl = URL(string: imageUrlString)
        imageView.kf.setImage(with: imageUrl)
        self.image = imageView.image
        titleLabel.text = title
        makeLayout(for: cardType)
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
    
    convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        self.image = image
        self.title = title
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
        makeLayout(for: cardType)
    }
    
    func remakeLayout(for cardType: CardType) {
        titleLabel.isHidden = true
        
        if cardType == .cell {
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(TodayViewController.SizeConstant.bigCellImageHeight)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        } else {
            imageView.snp.remakeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(TodayCardViewModel.SizeConstant.imageViewHeight)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
    
    func makeLayout(for cardType: CardType) {
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
                make.height.equalTo(TodayCardViewModel.SizeConstant.imageViewHeight)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }
}
