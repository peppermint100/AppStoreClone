//
//  Date+String.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

extension Date {
    func monthAndDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: self)
    }
}
