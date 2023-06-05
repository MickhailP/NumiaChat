//
//  DataLoadingView.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 05.06.2023.
//

import UIKit

final class NCDataLoadingView: UIView {

		override init(frame: CGRect) {
				super.init(frame: frame)
				configure()
		}

		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}

		private func configure() {

				alpha = 0

				translatesAutoresizingMaskIntoConstraints = false

				backgroundColor = .systemBackground

				UIView.animate(withDuration: 0.25) {
						self.alpha = 0.8
				}

				let activityIndicator = UIActivityIndicatorView(style: .large)
				addSubview(activityIndicator)
				activityIndicator.translatesAutoresizingMaskIntoConstraints = false

				activityIndicator.startAnimating()

				NSLayoutConstraint.activate([
						activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
						activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
						activityIndicator.widthAnchor.constraint(equalToConstant: 40),
						activityIndicator.heightAnchor.constraint(equalToConstant: 40)
				])
		}
}
