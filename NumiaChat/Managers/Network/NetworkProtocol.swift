//
//  NetworkProtocol.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import Foundation
import UIKit

protocol NetworkProtocol: AnyObject {

		func downloadDataResult(from url: URL?) async -> Result<Data, Error>
		func downloadImage(from url: String) async -> UIImage?
}


extension NetworkProtocol {

		/// Check if URLResponse have good status code, if it's not, it will throw an error
		/// - Parameter response: URLResponse from dataTask
		func handleResponse(_ response: URLResponse) throws {

				guard let response = response as? HTTPURLResponse else {
						throw ErrorMessage.invalidResponse
				}

				if response.statusCode >= 200 && response.statusCode <= 300 {
						return
				} else {
						throw ErrorMessage.statusCodeError
				}
		}
}


