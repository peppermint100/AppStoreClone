//
//  ItunesAppDetailViewModel.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/3/24.
//

import Foundation
import RxSwift


final class ItunesAppDetailViewModel: Coordinating {
    var coordinator: Coordinator
    var app: ItunesApp
    
    init(coordinator: Coordinator, app: ItunesApp) {
        self.app = app
        self.coordinator = coordinator
    }
    
    struct Input {
    }
    
    struct Output {
        let cells: Observable<[AppDetailTableViewCellType]>
        let cellHeights: Observable<[CGFloat]>
    }
    
    func transform(_ input: ItunesAppDetailViewModel.Input) -> ItunesAppDetailViewModel.Output {
        var additionalInfo: [AdditionalInfo] = [
            AdditionalInfo.nameAndValue(title: "제공자", value: app.artistName),
            AdditionalInfo.nameAndValue(title: "크기", value: app.fileSizeBytes),
            AdditionalInfo.nameAndValue(title: "카테고리", value: app.primaryGenreName),
            AdditionalInfo.nameAndValue(title: "언어", value: app.languageCodesISO2A.first!),
            AdditionalInfo.nameAndValue(title: "연령 등급", value: app.contentAdvisoryRating),
        ]
        
        if let sellerURL = app.sellerURL {
            additionalInfo.append(AdditionalInfo.link(alt: "개발자 웹사이트", urlString: sellerURL, iconImage: Symbols.safari!))
        }
        
        let cells = Observable<[AppDetailTableViewCellType]>.of([
            AppDetailTableViewCellType.headImage(urlString: app.artworkUrl512),
            AppDetailTableViewCellType.launchable(iconUrlString: app.artworkUrl512, title: app.trackName, subtitle: app.artistName, trackId: app.trackID),
            AppDetailTableViewCellType.summary(summaries: [
                AppSummaryString(title: "\(app.userRatingCount)개의 평가", subtitle: "\(ratingStar(rating: app.averageUserRatingForCurrentVersion))", value: String(format: "%0.1f", app.averageUserRatingForCurrentVersion)),
                AppSummaryString(title: "연령", subtitle: "세", value: "\(app.contentAdvisoryRating)"),
                AppSummaryImage(title: "개발자", subtitle: "\(app.artistName)", value: Symbols.personCropSquare!),
                AppSummaryString(title: "언어", subtitle: "\(app.languageCodesISO2A.count)개 언어", value: "\(app.languageCodesISO2A.first!)")
            ]),
            AppDetailTableViewCellType.description(desc: app.description),
            AppDetailTableViewCellType.screenshots(screenshotsUrlsString: app.screenshotUrls),
            AppDetailTableViewCellType.additionalInfo(infoList: additionalInfo)
        ])
        
        let screenshotDirection = getScreenshotDirection(urlString: app.screenshotUrls.first!)
        let screenshotHeight:CGFloat = screenshotDirection == .vertical ? SizeConstant.screenshotsVertical : SizeConstant.screenshotsHorizontal
        
        let cellHeights = Observable<[CGFloat]>.of([
            SizeConstant.headImageHeight,
            SizeConstant.launchable,
            SizeConstant.description,
            SizeConstant.appSummary,
            screenshotHeight,
            SizeConstant.infoList
        ])
        
        return ItunesAppDetailViewModel.Output(cells: cells, cellHeights: cellHeights)
    }
}

extension ItunesAppDetailViewModel {
    enum SizeConstant {
        static let headImageHeight: CGFloat = 220
        static let launchable: CGFloat = 150
        static let description: CGFloat = 120
        static let appSummary: CGFloat = 120
        static let screenshotsVertical: CGFloat = 600
        static let screenshotsHorizontal: CGFloat = 300
        static let infoList: CGFloat = 300
    }
    
    private func ratingStar(rating: Double) -> String {
        let intValue = Int(rating)
        
        if intValue > 5 {
            return "★★★★★"
        }
        
        if intValue < 0 {
            return "☆☆☆☆☆"
        }
        
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
    
    private func getScreenshotDirection(urlString: String) -> ScreenshotDirection {
        let pattern = "(\\d+)x(\\d+)"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = urlString as NSString
            let results = regex.matches(in: urlString, range: NSRange(location: 0, length: nsString.length))
            
            if let lastMatch = results.last,
               lastMatch.numberOfRanges == 3 {
                let widthString = nsString.substring(with: lastMatch.range(at: 1))
                let heightString = nsString.substring(with: lastMatch.range(at: 2))
                if let width = Int(widthString), let height = Int(heightString) {
                    return width > height ? .horizontal : .vertical
                }
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
        }
        
        return .vertical
    }
}

