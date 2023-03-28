public extension Array {
	subscript(safe index: Index) -> Element? {
		return self.indices ~= index ? self[index] : nil
	}
}
