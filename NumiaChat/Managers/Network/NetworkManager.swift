//
//  NetworkManager.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import Foundation
import UIKit


final class NetworkManager: NetworkProtocol {

		private let cache = NSCache<NSString, UIImage>()


		func downloadDataResult(from url: URL?) async -> Result<Data, Error> {

				guard let url = url else {
						return .failure( URLError(.badURL))
				}

				do {
						let (data, response) = try await URLSession.shared.data(from: url)
						try handleResponse(response)
						return .success(data)
				} catch  {
						print(error)
						print("There was an error during data fetching! ", error.localizedDescription)
						return .failure(error)
				}
		}


		func downloadImage(from url: String) async -> UIImage? {

				if let cachedImage = cache.object(forKey: NSString(string: url)) {
						return cachedImage
				} else if let fetchedImage = await fetchImage(from: url) {
						cache.setObject(fetchedImage, forKey: NSString(string: url))
						return fetchedImage
				}
				return nil
		}


		private func fetchImage(from urlString: String) async -> UIImage? {

				guard let url = URL(string: urlString) else   {
						return nil
				}

				do {
						let (data, response) = try await URLSession.shared.data(from: url)
						try handleResponse(response)
						return UIImage(data: data)
				} catch  {
						print(error)
						return nil
				}
		}
}
