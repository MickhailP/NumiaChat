//
//  EmptyView.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 03.06.2023.
//


import UIKit

class EmptyView: UIView {

		let messageLabel = NCTitleLabel(textAlignment: .center, fontSize: 28)

		override init(frame: CGRect) {
				super.init(frame: frame)
				configure()
				translatesAutoresizingMaskIntoConstraints = false
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


		convenience init(message: String) {
				self.init(frame: .zero)
				messageLabel.text = message
		}


		private func configure() {
				addSubview(messageLabel)

				messageLabel.numberOfLines = 0
				messageLabel.textColor = .secondaryLabel

				backgroundColor = .tertiarySystemBackground

				NSLayoutConstraint.activate([
						messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
						messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
						messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
						messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
				])

		}
}

