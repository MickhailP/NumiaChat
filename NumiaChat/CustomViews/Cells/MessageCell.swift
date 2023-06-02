//
//  MessageCell.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

final class MessageCell: UITableViewCell {

		let stackContainer = UIStackView()
		let messageContainer = UIView()

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
				configureStackView()
				configureImage()
				configureMessageContainer()
				setupLabel()

				contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
		}


		private func configureStackView() {
				contentView.addSubview(stackContainer)
				stackContainer.translatesAutoresizingMaskIntoConstraints = false
				stackContainer.axis = .horizontal
				stackContainer.distribution = .fill
				stackContainer.spacing = 20


				NSLayoutConstraint.activate([
						stackContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
						stackContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
						stackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
						stackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
				])
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
				stackContainer.addSubview(avatarImage)
				avatarImage.layer.cornerRadius = 20
				avatarImage.clipsToBounds = true

				NSLayoutConstraint.activate([
						avatarImage.topAnchor.constraint(equalTo: stackContainer.topAnchor, constant: Paddings.padding10),
						avatarImage.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor, constant:  -Paddings.padding10),
						avatarImage.widthAnchor.constraint(equalToConstant: 40),
						avatarImage.heightAnchor.constraint(equalToConstant: 40)
				])
		}

		
		private func configureMessageContainer() {
				stackContainer.addSubview(messageContainer)
				messageContainer.translatesAutoresizingMaskIntoConstraints = false
				messageContainer.layer.cornerRadius = 10
				messageContainer.backgroundColor = .secondarySystemBackground

				NSLayoutConstraint.activate([
						messageContainer.topAnchor.constraint(equalTo: stackContainer.topAnchor, constant: Paddings.padding10),
						messageContainer.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor, constant: Paddings.padding10),
						messageContainer.trailingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: -Paddings.padding10),
						messageContainer.bottomAnchor.constraint(equalTo: stackContainer.bottomAnchor, constant: -Paddings.padding10),
				])
		}


		override func prepareForReuse() {
				super.prepareForReuse()
				avatarImage.image = avatarImage.placeholder
		}
}
