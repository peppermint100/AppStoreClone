//
//  AppDetailTableViewCellType.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/4/24.
//

import UIKit

enum AppDetailTableViewCellType {
    case headImage(urlString: String)
    case launchable(iconUrlString: String, title: String, subtitle: String, trackId: Int)
    case description(desc: String)
    case summary(summaries: [AppSummary])
    case screenshots(screenshotsUrlsString: [String])
    case additionalInfo(infoList: [AdditionalInfo])
}


