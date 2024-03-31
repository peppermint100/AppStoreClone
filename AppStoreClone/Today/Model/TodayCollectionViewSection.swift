//
//  TodayCollectionViewSection.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

struct TodaySection: Hashable {
    let id: String
}

enum TodayItem: Hashable {
    case big(ItunesApp)
    case banner(ItunesApp)
    case list([ItunesApp])
    case floatingAppIcons([ItunesApp])
}
