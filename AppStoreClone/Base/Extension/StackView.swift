//
//  StackView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/3/24.
//

import UIKit
import SnapKit

extension UIStackView {
    func addDivider(of size: CGFloat, color: UIColor = .systemGray3) {
        let view = UIView()
        view.backgroundColor = color
        
        if axis == .vertical {
            view.snp.makeConstraints { make in
                make.height.equalTo(size)
            }
        } else {
            view.snp.makeConstraints { make in
                make.width.equalTo(size)
            }
        }
        
        addArrangedSubview(view)
    }
}
