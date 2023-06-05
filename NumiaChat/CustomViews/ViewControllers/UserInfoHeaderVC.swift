//
//  UserInfoVC.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 04.06.2023.
//

import UIKit

final class UserInfoHeaderVC: UIViewController {

		let message: Message

		let avatarImage = NCImageView(placeholder: Images.avatarPlaceholder)
		let usernameLabel = NCTitleLabel(textAlignment: .left, fontSize: 17)
		let timeLabel = NCBodyLabel(textAlignment: .left)


		override func viewDidLoad() {
				super.viewDidLoad()

				view.backgroundColor = .secondarySystemBackground

				setUIElements()
				configureImage()
				configureUsernameLabel()
				configureTimeLabel()
		}


		init(message: Message) {
				self.message = message
				super.init(nibName: nil, bundle: nil)
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}

		override func viewWillAppear(_ animated: Bool) {
				super.viewWillAppear(animated)

		}


		private func setUIElements() {
				avatarImage.getImage(from: message.avatarURL)
				usernameLabel.text = "Some Username VERY VERY LONG"
				timeLabel.text = "Sent: \(message.time.convertToHourMinutes())"
		}



		private func configureImage() {
				view.addSubview(avatarImage)

				avatarImage.layer.cornerRadius = 20
				avatarImage.clipsToBounds = true

				NSLayoutConstraint.activate([
						avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  Paddings.padding20),
						avatarImage.widthAnchor.constraint(equalToConstant: 90),
						avatarImage.heightAnchor.constraint(equalToConstant: 90),
						avatarImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
				])
		}


		private func configureUsernameLabel() {

				view.addSubview(usernameLabel)

				usernameLabel.numberOfLines = 2

				NSLayoutConstraint.activate([
						usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Paddings.padding20),
						usernameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant:  Paddings.padding20),
						usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.padding20)
				])
		}

		private func configureTimeLabel() {
				view.addSubview(timeLabel)


				NSLayoutConstraint.activate([
						timeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: Paddings.padding10),
						timeLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant:  Paddings.padding20),
						timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Paddings.padding10),
						timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.padding20)
				])
		}
}
