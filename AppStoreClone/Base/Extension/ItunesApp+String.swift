//
//  ItunesApp+String.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/15/24.
//

import Foundation

extension ItunesApp {
    
    func averageRatingStar() -> String {
        let intValue = Int(self.averageUserRating)
        var stars = ""
        
        for star in 1...5 {
            if star < intValue {
                stars += "★"
            } else {
                stars += "☆"
            }
        }
        
        return stars
    }
    
    func shortenRatingCount() -> String {
        let number = self.userRatingCount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1

        let thousand = 1000
        let million = 1000000

        switch number {
        case 1000..<million:
            let shortenedNumber = number / thousand
            return "\(numberFormatter.string(from: NSNumber(value: shortenedNumber))!)천"
        case million...:
            let shortenedNumber = number / million
            return "\(numberFormatter.string(from: NSNumber(value: shortenedNumber))!)만"
        default:
            return numberFormatter.string(from: NSNumber(value: number))!
        }
    }
}
