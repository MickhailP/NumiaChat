//
//  Endpints.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import Foundation


enum Endpoint {
		case getMessages(offset: Int = 0)
}


extension Endpoint {

		var scheme: String { "https" }

		var host: String { "numia.ru" }

		var path: String {
				switch self {
						case .getMessages:
								return "/api/getMessages"
				}
		}

		var queryItems: [String: String]? {
				switch self {
						case .getMessages(let offset):
								return ["offset": String(offset)]
				}
		}
}


extension Endpoint {
		var url: URL? {
				var components = URLComponents()
				components.scheme = scheme
				components.host = host
				components.path = path

				let queryItems = queryItems?.compactMap{ URLQueryItem(name: $0.key, value: $0.value) }

				components.queryItems = queryItems

				return components.url
		}
}

