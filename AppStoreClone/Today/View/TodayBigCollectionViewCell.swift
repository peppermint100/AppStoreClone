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
    
    let bgContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgContainer)
        
        bgContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(TodayViewController.SizeConstant.bigCellImageHeight)
        }
        
        bgContainer.layer.cornerRadius = 20
        bgContainer.clipsToBounds = true
        
        bgContainer.addSubview(bgImageView)
        bgContainer.addSubview(titleLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with app: ItunesApp) {
        titleLabel.text = app.trackName
        let url = URL(string: app.artworkUrl512)
        bgImageView.kf.indicatorType = .activity
        bgImageView.kf.setImage(with: url)
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
