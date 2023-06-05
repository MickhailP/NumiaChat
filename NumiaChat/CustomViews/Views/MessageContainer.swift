//
//  MessageContainer.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 04.06.2023.
//

import UIKit

final class MessageContainer: UIView {

		let messageText = NCBodyLabel()


		override init(frame: CGRect) {
				super.init(frame: frame)
				configureMessageContainer()
		}

		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


		func setMessageText(_ text: String){
				messageText.text = text
		}


		private func configureMessageContainer() {
				addSubview(messageText)

				messageText.numberOfLines = 0
				messageText.textColor = .secondaryLabel

				backgroundColor = .secondarySystemBackground
				translatesAutoresizingMaskIntoConstraints = false
				layer.cornerRadius = 10
				clipsToBounds = true

				messageText.pinToEdgesOf(view: self, constant: Paddings.padding10)
		}
}
