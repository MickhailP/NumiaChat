//
//  ErrorMessages.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import Foundation


enum ErrorMessage: String, Error {
		case badURl = "URL is invalid"
		case invalidUsername = "Wrong name"
		case invalidResponse = "Try again"
		case statusCodeError = "Status code is not 200-300"
		case invalidData = "Data is missing"
		case decodingError = "Decoding"
		case unableFetchFromDataBase = "Failed to load data from storage."
}
