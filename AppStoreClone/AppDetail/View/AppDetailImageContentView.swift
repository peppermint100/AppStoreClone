//
//  AppDetailImageContentView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/5/24.
//

import UIKit

class AppDetailImageContentView: UIView {
    let iv = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(iv)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with urlString: String) {
        let url = URL(string: urlString)
        iv.kf.setImage(with: url)
    }
}
