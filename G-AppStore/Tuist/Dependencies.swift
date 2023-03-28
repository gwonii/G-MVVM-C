import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: .init(
        [
            .remote(url: "https://github.com/Swinject/Swinject", requirement: .upToNextMinor(from: "2.8.0")),
            .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMinor(from: "5.6.0")),
            .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMinor(from: "7.4.0")),
			.remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMinor(from: "5.6.0")),
			.remote(url: "https://github.com/CombineCommunity/CombineCocoa.git", requirement: .upToNextMinor(from: "0.4.0")),
			.remote(url: "https://github.com/evgenyneu/Cosmos.git", requirement: .upToNextMinor(from: "23.0.0"))
        ]
    ),
    platforms: [.iOS]
)
