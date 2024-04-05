//
//  UIWindow.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit

extension UIWindow {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}
