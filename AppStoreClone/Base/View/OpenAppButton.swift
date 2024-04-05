//
//  OpenAppButton.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit

class OpenAppButton: UIButton {
    
    var trackId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("열기", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        backgroundColor = .systemGray5
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(trackId: Int) {
        self.trackId = trackId
        addTarget(self, action: #selector(open(_:)), for: .touchUpInside)
    }
    
    @objc private func open(_ sender: OpenAppButton) {
        if let trackId = sender.trackId {
            let url = "itms-apps://itunes.apple.com/app/apple-store/id\(trackId)?mt=8"
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
