import Foundation
import CommonData
import Alamofire

enum StoreAPI: NetworkAPI {
	case getTracks(term: String)
	
	var scheme: String {
		return "https"
	}
	
	var host: String {
		return "itunes.apple.com"
	}
	
	var path: String {
		switch self {
			case .getTracks:
				return "search"
		}
	}
	
	var method: HTTPMethod {
		switch self {
			case .getTracks:
				return .get
		}
	}
	
	var headers: HTTPHeaders {
		return []
	}

	var parameters: Parameters {
		switch self {
			case .getTracks(let term):
				return [
					"term": term,
					"media": "software",
					"lang": "ko_kr"
				]
		}
	}
	
	var baseURL: URL? {
		return URL(string: "\(scheme)://\(host)")
	}
	
	var description: String {
		return "\(scheme)://\(host)/\(path)?\(parameters)"
	}
}
