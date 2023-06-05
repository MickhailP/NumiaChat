//
//  ViewController.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

protocol ChatTextfieldDelegate: AnyObject {

		func didTapSendButton(with message: String)
}


final class ChatTextfieldVC: UIViewController {

		weak var delegate: ChatTextfieldDelegate? 

		let messageTextField = NCTextField()
		let sendButton = NCSendButton()

		var message = ""


		init(delegate: ChatTextfieldDelegate) {
				super.init(nibName: nil, bundle: nil)
				self.delegate = delegate
		}

		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


    override func viewDidLoad() {
        super.viewDidLoad()
				configureSendButton()
				configureTextField()
    }

}


//MARK: - Views configurations
extension ChatTextfieldVC {

		private func configureTextField() {
				view.addSubview(messageTextField)

				messageTextField.delegate = self
				messageTextField.placeholder = "Message..."

				NSLayoutConstraint.activate([
						messageTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Paddings.padding10),
						messageTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -Paddings.padding10),
						messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -Paddings.padding10),
						messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.padding10),
				])
		}


		private func configureSendButton() {
				view.addSubview(sendButton)

				sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

				NSLayoutConstraint.activate([
						sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Paddings.padding10),
						sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.padding10),
						sendButton.heightAnchor.constraint(equalToConstant: 40),
						sendButton.widthAnchor.constraint(equalToConstant: 40)
				])
		}


		@objc func sendButtonTapped() {
				if checkOutText(from: messageTextField) {
						delegate?.didTapSendButton(with: message)
				}
		}
}


//MARK: - UITextFieldDelegate
extension ChatTextfieldVC: UITextFieldDelegate {

		func textFieldShouldReturn(_ textField: UITextField) -> Bool {

				if checkOutText(from: textField) {
						delegate?.didTapSendButton(with: message)
				}

				textField.resignFirstResponder()
				return true
		}

		private func checkOutText(from textField: UITextField) -> Bool {
				if let message = textField.text,
					 !message.isEmpty {
						self.message = message
						textField.text = ""
						return true
				} else {
						return false
				}
		}
}
