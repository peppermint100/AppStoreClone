//
//  OpenAppButton.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit

class OpenAppButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("열기", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
