//
//  UIView+Extension.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/19/24.
//

import UIKit

extension UIView {
    func createSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        drawHierarchy(in: frame, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
