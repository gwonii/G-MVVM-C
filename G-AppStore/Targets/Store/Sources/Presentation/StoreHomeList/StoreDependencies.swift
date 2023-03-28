protocol StoreDependencies {
	var trackRepository: trackRepository { get }
	var searchedTermRepository: SearchedTermRepository { get }
}

struct DefaultStoreDependencies: StoreDependencies {
	init(
		_ trackRepository: trackRepository,
		_ searchedTermRepository: SearchedTermRepository
	) {
		self.trackRepository = trackRepository
		self.searchedTermRepository = searchedTermRepository
	}
	
	let trackRepository: trackRepository
	let searchedTermRepository: SearchedTermRepository
}
