import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
let baseBundleID: String = "com.gwonii.hc.g-mvvm-c"

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project: Project = .init(
	name: "iOSApp",
	organizationName: "Hogwon Choi",
	targets:
		[
			makeAppTargets(
				name: "iosApp",
				platform: .iOS,
				dependencies:
					[
						.target(name: "CommonUI"),
						.target(name: "Home"),
						.target(name: "GitHubRepositories")
					]
			),
			makeFrameworkTargets(
				name: "Common",
				platform: .iOS,
				dependencies:
					[
						.external(name: "CombineExt"),
						.external(name: "Swinject"),
						.external(name: "SwiftyBeaver")
					]
			),
			makeFrameworkTargets(
				name: "CommonUI",
				platform: .iOS,
				dependencies:
					[
						.external(name: "SnapKit"),
						.external(name: "Kingfisher"),
						.external(name: "CombineCocoa"),
						.external(name: "CombineDataSources")
					]
			),
			makeFrameworkTargets(
				name: "CommonData",
				platform: .iOS,
				dependencies:
					[
						.external(name: "Alamofire")
					]
			),
			makeFrameworkTargets(
				name: "Home",
				platform: .iOS,
				dependencies:
					[
						.target(name: "CommonUI"),
						.target(name: "CommonData"),
						.target(name: "GitHubRepositories")
					]
			),
			makeFrameworkTargets(
				name: "GitHubRepositories",
				platform: .iOS,
				dependencies:
					[
						.target(name: "CommonUI"),
						.target(name: "CommonData")
					]
			),
		].flatMap { $0 }
)

func makeAppTargets(
	name: String,
	platform: Platform,
	dependencies: [TargetDependency] = []
) -> [Target] {
	let platform: Platform = platform
	let infoPlist: [String: InfoPlist.Value] = [
		"UISupportedInterfaceOrientations": [
			"UIInterfaceOrientationPortrait"
		],
		"NSAppTransportSecurity": [
			"NSAllowsArbitraryLoads": true
		],
		"UIUserInterfaceStyle": "Automatic",
		"CFBundleShortVersionString": "1.0.0",
		"CFBundleVersion": "1",
		"UIMainStoryboardFile": "",
		"UILaunchStoryboardName": "LaunchScreen",
		"CFBundleDisplayName": "${DISPLAY_NAME}",
		"CFBundleIdentifier": "${BUNDLE_IDENTIFIER}"
	]

	let mainTarget = Target(
		name: name,
		platform: platform,
		product: .app,
		bundleId: "${BUNDLE_IDENTIFIER}",
		deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
		infoPlist: .extendingDefault(with: infoPlist),
		sources: ["Targets/\(name)/Sources/**"],
		resources: ["Targets/\(name)/Resources/**"],
		dependencies: dependencies,
		settings: .settings(
			base: SettingsDictionary()
				.automaticCodeSigning(devTeam: "FJHLD62USU"),
			configurations: [
				.debug(
					name: "Debug",
					settings: [
						"BUNDLE_IDENTIFIER": "\(baseBundleID)-dev",
						"DISPLAY_NAME": "G-MVVM-C-dev"
					]
				),
				.release(
					name: "Release",
					settings: [
						"BUNDLE_IDENTIFIER": "\(baseBundleID)",
						"DISPLAY_NAME": "G-MVVM-C"
					]
				)
			]
		)
	)
	return [mainTarget]
}

func makeFrameworkTargets(
	name: String,
	platform: Platform,
	dependencies: [TargetDependency]
) -> [Target] {
	let sources = Target(
		name: name,
		platform: platform,
		product: .framework,
		bundleId: "\(baseBundleID).\(name)",
		deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
		infoPlist: .default,
		sources: ["Targets/\(name)/Sources/**"],
		resources: name == "CommonUI" ? ["Targets/\(name)/Resources/**"] : [],
		dependencies: dependencies,
		settings: .settings(
			base: SettingsDictionary(),
			configurations: [
				.debug(
					name: "Debug",
					settings: [
						"BUNDLE_IDENTIFIER": "\(baseBundleID).\(name)"
					]
				),
				.release(
					name: "Release",
					settings: [
						"BUNDLE_IDENTIFIER": "\(baseBundleID).\(name)"
					]
				)
			]
		)
	)
	
	let tests = Target(
		name: "\(name)Tests",
		platform: platform,
		product: .unitTests,
		bundleId: "\(baseBundleID).\(name)Tests",
		deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
		infoPlist: .default,
		sources: ["Targets/\(name)/Tests/**"],
		resources: [],
		dependencies: [.target(name: name)],
		settings: .settings(
			base: SettingsDictionary(),
			configurations: [
				.debug(
					name: "Debug",
					settings: [
						"BUNDLE_IDENTIFIER": "\(baseBundleID).\(name)Tests"
					]
				),
				.release(
					name: "Release",
					settings: [
						"BUNDLE_IDENTIFIER": "\(baseBundleID).\(name)Tests"
					]
				)
			]
		)
	)
	
	return [sources, tests]
}
