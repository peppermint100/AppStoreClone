//
//  BackgroundCollectionReusableView.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/14/24.
//

import UIKit

class BackgroundCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "BackgroundCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradient(colors: [
            UIColor(red: 63/255, green: 202/255, blue: 101/255, alpha: 0.8),
            UIColor(red: 125/255, green: 235/255, blue: 155/255, alpha: 0.8)],
                      startPoint: CGPoint(x: 0.9,y: 0.5), endPoint: CGPoint(x: 1,y: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
