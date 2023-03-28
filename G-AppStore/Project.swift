import ProjectDescription
import MyPlugin

// MARK: - Project
let appName: String = "G-AppStore"

let project: Project = .init(
	name: appName,
	organizationName: "${ORGANIZATION_NAME}",
	targets:
		[
			makeAppTargets(
				name: appName,
				platform: .iOS,
				dependencies:
					[
						.target(name: "DIContainer"),
						.target(name: "Store")
					]
			),
			makeFrameworkTargets(
				name: "DIContainer",
				platform: .iOS,
				dependencies:
					[
						.external(name: "Swinject")
					]
			),
			makeFrameworkTargets(
				name: "Common",
				platform: .iOS,
				dependencies: []
			),
			makeFrameworkTargets(
				name: "CommonUI",
				platform: .iOS,
				dependencies:
					[
						.target(name: "Common"),
						.external(name: "SnapKit"),
						.external(name: "Kingfisher"),
						.external(name: "CombineCocoa"),
						.external(name: "Cosmos")
					]
			),
			makeFrameworkTargets(
				name: "CommonData",
				platform: .iOS,
				dependencies:
					[
						.target(name: "Common"),
						.target(name: "DIContainer"),
						.external(name: "Alamofire")
					]
			),
			makeFrameworkTargets(
				name: "Store",
				platform: .iOS,
				dependencies:
					[
						.target(name: "DIContainer"),
						.target(name: "CommonUI"),
						.target(name: "CommonData")
					]
			)
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
				.automaticCodeSigning(devTeam: "${DEV_TEAM}"),
			configurations: [
				.debug(
					name: "Debug",
					settings: [
						"BUNDLE_IDENTIFIER": "${BUNDLE_ID}-dev",
						"DISPLAY_NAME": "\(appName)-dev"
					],
					xcconfig: appName == name ? .init("Secrets.xcconfig") : nil
				),
				.release(
					name: "Release",
					settings: [
						"BUNDLE_IDENTIFIER": "${BUNDLE_ID}",
						"DISPLAY_NAME": "\(appName)"
					],
					xcconfig: appName == name ? .init("Secrets.xcconfig") : nil
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
		bundleId: "${BUNDLE_ID}.\(name)",
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
						"BUNDLE_IDENTIFIER": "${BUNDLE_ID}.\(name)"
					],
					xcconfig: appName == name ? .init("Secrets.xcconfig") : nil
				),
				.release(
					name: "Release",
					settings: [
						"BUNDLE_IDENTIFIER": "${BUNDLE_ID}.\(name)"
					],
					xcconfig: appName == name ? .init("Secrets.xcconfig") : nil
				)
			]
		)
	)
	
	let tests = Target(
		name: "\(name)Tests",
		platform: platform,
		product: .unitTests,
		bundleId: "${BUNDLE_ID}.\(name)Tests",
		deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
		infoPlist: .default,
		sources: ["Targets/\(name)/Tests/**"],
		resources: name == "Store" ? ["Targets/\(name)/Tests/Resources/**"] : [],
		dependencies: [.target(name: name)],
		settings: .settings(
			base: SettingsDictionary(),
			configurations: [
				.debug(
					name: "Debug",
					settings: [
						"BUNDLE_IDENTIFIER": "${BUNDLE_ID}.\(name)Tests"
					]
				),
				.release(
					name: "Release",
					settings: [
						"BUNDLE_IDENTIFIER": "${BUNDLE_ID}.\(name)Tests"
					]
				)
			]
		)
	)
	return name == "Store" ? [sources, tests] : [sources]
}
