import Foundation

public protocol UserDefaultsStore {
	func saveRawValue<RawValue>(_ value: RawValue, for key: String)

	func findRawValue<RawValue>(for key: String) -> RawValue?

	func delete(for key: String)
}

public final class DefaultUserDefaultsStore: UserDefaultsStore {
	public init(userDefautls: UserDefaults = .standard) {
		self.userDefaults = userDefautls
	}
	
	private let userDefaults: UserDefaults
	
	public func saveRawValue<RawValue>(_ value: RawValue, for key: String) {
		userDefaults.setValue(value, forKey: key)
	}
	
	public func findRawValue<RawValue>(for key: String) -> RawValue? {
		return userDefaults.value(forKey:key) as? RawValue
	}
	
	public func delete(for key: String) {
		userDefaults.removeObject(forKey: key)
	}
}
