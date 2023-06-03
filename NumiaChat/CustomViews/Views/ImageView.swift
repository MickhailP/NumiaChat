//
//  ImageView.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 02.06.2023.
//

import UIKit

final class NCImageView: UIImageView {

		var networkingManager: NetworkProtocol?

		var placeholder: UIImage?


		convenience init(placeholder: UIImage?, networkingManager: NetworkProtocol = NetworkManager()) {
				self.init(frame: .zero)
				self.networkingManager = networkingManager
				self.placeholder = placeholder
		}


		override init(frame: CGRect) {
				super.init(frame: frame)
				configure()
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


		private func configure() {
				clipsToBounds = true
				contentMode = .scaleAspectFill

				if let placeholder {
						image = placeholder

				}

				translatesAutoresizingMaskIntoConstraints = false
		}


		func getImage(from url: String) {
				Task {
						if let image = await networkingManager?.downloadImage(from: url) {
								await MainActor.run {
										self.image = image
								}
						}
				}
		}
}
