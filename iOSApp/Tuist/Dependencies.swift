import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: .init(
        [
            .remote(url: "https://github.com/Swinject/Swinject", requirement: .upToNextMinor(from: "2.8.0")),
            .remote(url: "https://github.com/krzysztofzablocki/Inject.git", requirement: .upToNextMinor(from: "1.2.0")),
            .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMinor(from: "5.6.0")),
            .remote(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", requirement: .upToNextMinor(from: "1.9.0")),
            .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMinor(from: "7.4.0")),
			.remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMinor(from: "5.6.0")),
			.remote(url: "https://github.com/CombineCommunity/CombineCocoa.git", requirement: .upToNextMinor(from: "0.4.0")),
			.remote(url: "https://github.com/CombineCommunity/CombineDataSources.git", requirement: .upToNextMinor(from: "0.2.0")),
			.remote(url: "https://github.com/CombineCommunity/CombineExt.git", requirement: .upToNextMinor(from: "1.8.0")),
			.remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMinor(from: "4.1.0"))
        ]
    ),
    platforms: [.iOS]
)
