//
//  MessageCell.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

final class MessageCell: UITableViewCell {

		let messageContainer = MessageContainer(frame: .zero)

		let messageText: UILabel = NCBodyLabel()
		let avatarImage = NCImageView(placeholder: Images.avatarPlaceholder)


		override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
				super.init(style: style, reuseIdentifier: reuseIdentifier)
				configureCell()
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}

		func setCell(with message: Message) {
				messageText.text = message.text
				avatarImage.getImage(from: message.avatarURL)
		}


		private func configureCell() {
//				configureStackView()
				configureImage()
				configureMessageContainer()
				setupLabel()

				contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
		}

		
		private func setupLabel() {
				contentView.addSubview(messageText)

				NSLayoutConstraint.activate([
						messageText.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 5),
						messageText.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -5),
						messageText.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 5),
						messageText.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -5),
						
				])
		}


		private func configureImage() {
				contentView.addSubview(avatarImage)
				avatarImage.layer.cornerRadius = 20
				avatarImage.clipsToBounds = true

				NSLayoutConstraint.activate([
						avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Paddings.padding10),
						avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -Paddings.padding10),
						avatarImage.widthAnchor.constraint(equalToConstant: 40),
						avatarImage.heightAnchor.constraint(equalToConstant: 40)
				])
		}

		
		private func configureMessageContainer() {
				contentView.addSubview(messageContainer)

				NSLayoutConstraint.activate([
						messageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Paddings.padding10),
						messageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Paddings.padding10),
						messageContainer.trailingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: -Paddings.padding10),
						messageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Paddings.padding10),
				])
		}


		override func prepareForReuse() {
				super.prepareForReuse()
				avatarImage.image = avatarImage.placeholder
		}
}
