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

		let padding: CGFloat = 10

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
				messageTextField.placeholder = "Message"

				NSLayoutConstraint.activate([
						messageTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
						messageTextField.heightAnchor.constraint(equalToConstant: 40),
						messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -padding),
						messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
				])
		}


		private func configureSendButton() {
				view.addSubview(sendButton)

				sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

				NSLayoutConstraint.activate([
						sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
						sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
						sendButton.heightAnchor.constraint(equalToConstant: 40),
						sendButton.widthAnchor.constraint(equalToConstant: 40)
				])
		}


		@objc func sendButtonTapped() {
				print("button tapped")
				if let message = messageTextField.text {
						delegate?.didTapSendButton(with: message)
						messageTextField.text = ""
				}
		}
}


//MARK: - UITextFieldDelegate
extension ChatTextfieldVC: UITextFieldDelegate {

		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
				print("return tapped")
				if let message = textField.text {
						delegate?.didTapSendButton(with: message)
						textField.text = ""
				}

				textField.resignFirstResponder()
				return true
		}
}
