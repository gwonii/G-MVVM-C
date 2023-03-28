struct Track: Hashable {
	let trackName: String
	let description: String
	let screenshotUrls: [String]
	let artistName: String
	let genres: [String]
	let price: Int
	
	/// thumbnail image
	let artworkURL60: String
	let artworkURL100: String
	
	/// 평가 총 개수
	let userRatingCount: Int
	
	/// 평균 평점
	let averageUserRating: Double
	
	/// 최소 연령
	let trackContentRating: String
	
	/// 언어
	let languageCodesISO2A: [String]
	
	init(from response: ItunesResult) {
		self.trackName = response.trackName ?? "익명의 앱"
		self.description = response.description ?? "개발자가 제공하는 설명이 없습니다."
		self.screenshotUrls = response.screenshotUrls ?? []
		self.artistName = response.artistName ?? "익명의 개발자"
		self.genres = response.genres ?? []
		self.price = Int(response.price ?? 0.0)
		self.artworkURL60 = response.artworkUrl60 ?? "nil"
		self.artworkURL100 = response.artworkUrl100 ?? "nil"
		self.userRatingCount = response.userRatingCount ?? 0
		self.averageUserRating = response.averageUserRating ?? 0
		self.trackContentRating = response.trackContentRating ?? "1+"
		self.languageCodesISO2A = response.languageCodesISO2A ?? ["KO"]
	}
}
