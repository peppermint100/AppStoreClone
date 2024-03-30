//
//  ItunesResponse.swift
//  AppStoreClone
//
//  Created by peppermint100 on 3/30/24.
//

import Foundation

// MARK: - AppStoreResponse
struct ItunesResponse: Codable {
    let resultCount: Int
    let results: [ItunesApp]
}

// MARK: - Result
struct ItunesApp: Codable {
    let artistViewURL: String
    let artworkUrl60, artworkUrl512, artworkUrl100: String
    let screenshotUrls: [String]
    let isGameCenterEnabled: Bool
    let ipadScreenshotUrls: [String]
    let supportedDevices, features, advisories: [String]
    let kind, formattedPrice, contentAdvisoryRating: String
    let userRatingCountForCurrentVersion: Int
    let trackContentRating: String
    let averageUserRatingForCurrentVersion, averageUserRating: Double
    let minimumOSVersion, trackCensoredName: String
    let languageCodesISO2A: [String]
    let fileSizeBytes: String
    let sellerURL, trackViewURL: String
    let genreIDS: [String]
    let primaryGenreName: String
    let primaryGenreID, trackID: Int
    let trackName, releaseNotes: String
    let artistID: Int
    let artistName: String
    let genres: [String]
    let price: Int
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

