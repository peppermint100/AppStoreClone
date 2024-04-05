//
//  AppSummary.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/5/24.
//

import UIKit

protocol AppSummary {
    var title: String { get set }
    var subtitle: String { get set }
}

struct AppSummaryString: AppSummary {
    var title: String
    var subtitle: String
    var value: String
}

struct AppSummaryImage: AppSummary {
    var title: String
    var subtitle: String
    var value: UIImage
}
