//
//  TodayCollectionViewSection.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

enum TodaySection: Hashable {
    case today
    case adBanner
    case vertical(String, String)
}

enum TodayItem: Hashable {
    case big(ItunesApp)
    case banner(ItunesApp)
    case list(ItunesApp)
}
