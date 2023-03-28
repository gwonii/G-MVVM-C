import Foundation

// MARK: - Welcome
struct ItunesResponse: Decodable {
	let resultCount: Int
	let results: [ItunesResult]?
}

// MARK: - Result
struct ItunesResult: Decodable {
	let supportedDevices, advisories, features: [String]?
	let isGameCenterEnabled: Bool?
	let screenshotUrls: [String]?
	let ipadScreenshotUrls: [String]?
	let appletvScreenshotUrls: [String]?
	let artworkUrl60, artworkUrl512, artworkUrl100: String?
	let artistViewURL: String?
	let kind: String?
	let artistID: Int?
	let artistName: String?
	let genres: [String]?
	let price: Double?
	let description, primaryGenreName: String?
	let primaryGenreID, trackID: Int?
	let trackName, bundleID, sellerName: String?
	let genreIDS: [String]?
	let releaseNotes: String?
	let isVppDeviceBasedLicensingEnabled: Bool?
	let currentVersionReleaseDate: String?
	let currency, minimumOSVersion, trackCensoredName: String?
	let languageCodesISO2A: [String]?
	let fileSizeBytes: String?
	let sellerURL: String?
	let formattedPrice, contentAdvisoryRating: String?
	let averageUserRatingForCurrentVersion: Double?
	let userRatingCountForCurrentVersion: Int?
	let averageUserRating: Double?
	let trackViewURL: String?
	let trackContentRating: String?
	let releaseDate: String?
	let version, wrapperType: String?
	let userRatingCount: Int?

	enum CodingKeys: String, CodingKey {
		case supportedDevices, advisories, features, isGameCenterEnabled, screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100
		case artistViewURL = "artistViewUrl"
		case kind
		case artistID = "artistId"
		case artistName, genres, price, description, primaryGenreName
		case primaryGenreID = "primaryGenreId"
		case trackID = "trackId"
		case trackName
		case bundleID = "bundleId"
		case sellerName
		case genreIDS = "genreIds"
		case releaseNotes, isVppDeviceBasedLicensingEnabled, currentVersionReleaseDate, currency
		case minimumOSVersion = "minimumOsVersion"
		case trackCensoredName, languageCodesISO2A, fileSizeBytes
		case sellerURL = "sellerUrl"
		case formattedPrice, contentAdvisoryRating, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, averageUserRating
		case trackViewURL = "trackViewUrl"
		case trackContentRating, releaseDate, version, wrapperType, userRatingCount
	}
}
