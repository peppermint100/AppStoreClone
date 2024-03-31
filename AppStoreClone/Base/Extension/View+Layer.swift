//
//  View+Gradient.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit

extension UIView {
    func labelGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
