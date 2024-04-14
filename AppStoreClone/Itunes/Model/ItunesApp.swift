//
//  ItunesApp.swift
//  AppStoreClone
//
//  Created by peppermint100 on 4/1/24.
//

import Foundation

struct ItunesApp: Codable, Hashable {
    let artistViewURL: String
    let artworkUrl60, artworkUrl512, artworkUrl100: String
    let screenshotUrls: [String]
    let isGameCenterEnabled: Bool
    let ipadScreenshotUrls: [String]
    let supportedDevices, features, advisories: [String]
    let kind, contentAdvisoryRating: String
    let formattedPrice: String?
    let userRatingCountForCurrentVersion: Int
    let trackContentRating: String
    let averageUserRatingForCurrentVersion, averageUserRating: Double
    let minimumOSVersion, trackCensoredName: String
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let sellerURL: String?
    let trackViewURL: String
    let genreIDS: [String]
    let primaryGenreName: String
    let primaryGenreID, trackID: Int
    let trackName: String
    let releaseNotes: String?
    let artistID: Int
    let artistName: String
    let genres: [String]
    let price: Int?
    let description: String
    let releaseDate: Date
    let bundleID, sellerName: String
    let currentVersionReleaseDate: Date
    let currency, version, wrapperType: String
    let isVppDeviceBasedLicensingEnabled: Bool
    let userRatingCount: Int

    enum CodingKeys: String, CodingKey {
        case artistViewURL = "artistViewUrl"
        case artworkUrl60, artworkUrl512, artworkUrl100, screenshotUrls, isGameCenterEnabled, ipadScreenshotUrls, supportedDevices, features, advisories, kind, formattedPrice, contentAdvisoryRating, userRatingCountForCurrentVersion, trackContentRating, averageUserRatingForCurrentVersion, averageUserRating
        case minimumOSVersion = "minimumOsVersion"
        case trackCensoredName, languageCodesISO2A, fileSizeBytes
        case sellerURL = "sellerUrl"
        case trackViewURL = "trackViewUrl"
        case genreIDS = "genreIds"
        case primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case trackID = "trackId"
        case trackName, releaseNotes
        case artistID = "artistId"
        case artistName, genres, price, description, releaseDate
        case bundleID = "bundleId"
        case sellerName, currentVersionReleaseDate, currency, version, wrapperType, isVppDeviceBasedLicensingEnabled, userRatingCount
    }
}
