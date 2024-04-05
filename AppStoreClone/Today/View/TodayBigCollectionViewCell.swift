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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.title
        label.numberOfLines = 2
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = Fonts.subtitle
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgImageView)
        
        bgImageView.frame = CGRect(x: 0, y: 0, width: SizeConstant.bigCellImageWidth, height: SizeConstant.bigCellImageHeight)
        bgImageView.layer.cornerRadius = 20
        bgImageView.clipsToBounds = true
        
        bgImageView.addSubview(titleLabel)
        bgImageView.addSubview(descLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(descLabel.snp.top)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with app: ItunesApp) {
        titleLabel.text = app.trackName
        descLabel.text = app.description
        let url = URL(string: app.artworkUrl512)
        bgImageView.kf.indicatorType = .activity
        bgImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                guard let averageColor = value.image.averageColor else { return }
                self?.bgImageView.labelGradient(.bottomLeft, .soft)
            case .failure(_):
                return
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TodayBigCollectionViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bounceAnimate(isTouched: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        bounceAnimate(isTouched: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        bounceAnimate(isTouched: false)
    }
    
    private func bounceAnimate(isTouched: Bool) {
        if isTouched {
            TodayBigCollectionViewCell.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: [.allowUserInteraction], animations: {
                            self.transform = .init(scaleX: 0.97, y: 0.97)
                            self.layoutIfNeeded()
                           }, completion: nil)
        } else {
            TodayBigCollectionViewCell.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                            self.transform = .identity
                           }, completion: nil)
        }
    }
}
