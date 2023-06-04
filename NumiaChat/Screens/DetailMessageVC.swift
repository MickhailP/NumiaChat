//
//  DetailMessageVC.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 04.06.2023.
//

import UIKit


final class DetailMessageVC: UIViewController {

		let message: Message

		let contentView = UIView()

		let messageInfoHeader = UIView()
		let messageTextView = MessageContainer(frame: .zero)



		init(message: Message) {
				self.message = message
				super.init(nibName: nil, bundle: nil)
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


		override func viewDidLoad() {
				super.viewDidLoad()
				configureVC()
				configureUIElements()

				configureContentView()
				configureMessageInfoHeader()
				configureMessageTextView()

				setAlfaOfUIElementsToZero()

		}

		override func viewWillAppear(_ animated: Bool) {
				super.viewWillAppear(animated)
				self.title = ""
		}

		override func viewDidAppear(_ animated: Bool) {
				super.viewDidAppear(animated)
				fadeOutUIElements()
		}

		private func configureVC() {
				navigationController?.isNavigationBarHidden = false
				navigationController?.navigationBar.prefersLargeTitles = false

				view.backgroundColor = .systemTeal
				let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMessage))
				navigationItem.rightBarButtonItem = deleteButton
		}

		@objc func deleteMessage() {
				print("DELETE")
		}


		private func configureContentView() {
				view.addSubview(contentView)

				contentView.translatesAutoresizingMaskIntoConstraints = false
				contentView.backgroundColor = .systemBackground

				NSLayoutConstraint.activate([
						contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
						contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
						contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
						contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
				])
		}


		private func configureMessageInfoHeader() {
				contentView.addSubview(messageInfoHeader)

				messageInfoHeader.translatesAutoresizingMaskIntoConstraints = false
				messageInfoHeader.layer.cornerRadius = 10
				messageInfoHeader.backgroundColor = .blue

				NSLayoutConstraint.activate([
						messageInfoHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Paddings.padding20),
						messageInfoHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Paddings.padding10),
						messageInfoHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Paddings.padding10),
						messageInfoHeader.heightAnchor.constraint(equalToConstant: 130)
				])
		}

		private func configureMessageTextView() {
				contentView.addSubview(messageTextView)
				messageTextView.translatesAutoresizingMaskIntoConstraints = false

				messageTextView.layer.cornerRadius = 10
				messageTextView.clipsToBounds = true
				messageTextView.backgroundColor = .secondarySystemBackground

				NSLayoutConstraint.activate([
						messageTextView.topAnchor.constraint(equalTo: messageInfoHeader.bottomAnchor, constant: Paddings.padding10),
						messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Paddings.padding10),
						messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Paddings.padding10),
				])
		}


		private func configureUIElements() {
				let headerVC = UserInfoHeaderVC(message: message)
				add(childVC: headerVC, to: messageInfoHeader)

				messageTextView.setMessageText(message.text)
		}

		private func setAlfaOfUIElementsToZero() {
				messageInfoHeader.alpha = 0
				messageTextView.alpha = 0
		}

		private func fadeOutUIElements() {
				let views = [messageInfoHeader, messageTextView]

				UIView.animate(
						withDuration: 0.5,
						animations: {
								views.forEach { view in
										view.alpha = 1
								}
						})
		}
}

