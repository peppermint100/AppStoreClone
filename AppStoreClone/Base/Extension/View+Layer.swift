//
//  View+Gradient.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/31/24.
//

import UIKit

enum GradientDirection {
    case bottom
    case bottomLeft
}

enum GradientAccent: CGFloat {
    case soft = 0.2
    case medium = 0.5
    case hard = 0.8
}

extension UIView {
    func labelGradient(_ direction: GradientDirection = .bottomLeft, _ accent: GradientAccent = .medium) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(accent.rawValue).cgColor]
        
        switch direction {
        case .bottomLeft:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.3)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottom:
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func shadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 12
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}
