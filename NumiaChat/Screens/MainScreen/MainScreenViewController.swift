//
//  MainScreenViewController.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

class MainScreenViewController: UIViewController, ChatTextfieldDelegate {
		func didTapSendButton(with message: String) {
				print("feleate")
		}
		
		let textFieldView = UIView()

		var messages: [Message] = []


		override func viewDidLoad() {
				super.viewDidLoad()

				configureTextFieldView()

				view.backgroundColor = .blue
		}


		func configureTextFieldView() {

				let textFieldVC = ChatTextfieldVC(delegate: self)
				add(childVC: textFieldVC, to: textFieldView)

				view.addSubview(textFieldView)
				textFieldView.translatesAutoresizingMaskIntoConstraints = false

				let padding: CGFloat = 10

				NSLayoutConstraint.activate([
						textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
						textFieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
						textFieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
						textFieldView.heightAnchor.constraint(equalToConstant: 70)
				])

		}


		private func add(childVC: UIViewController, to containerView: UIView) {
				addChild(childVC)
				containerView.addSubview(childVC.view)
				childVC.view.frame = containerView.bounds
				childVC.didMove(toParent: self)
				containerView.layer.masksToBounds = true
		}

}

