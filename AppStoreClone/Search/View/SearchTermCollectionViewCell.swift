//
//  SearchTermCollectionViewCell.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import UIKit

class SearchTermCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchTermCollectionViewCell"
    
    private let termLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.footnote
        label.textColor = .systemBlue
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(termLabel)
        contentView.addSubview(divider)
        
        termLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(termLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with term: String) {
        let glassImageAttachment = NSTextAttachment()
        let image = Symbols.magnifyingglass?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        glassImageAttachment.image = image
        glassImageAttachment.image?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        let glassImageString = NSAttributedString(attachment: glassImageAttachment)
        let termText = NSMutableAttributedString(attributedString: glassImageString)
        let attributes: [NSAttributedString.Key: Any] = [.font: Fonts.list]
        termText.append(NSAttributedString(string: "  \(term)", attributes: attributes))
        termLabel.attributedText = termText
    }
}
