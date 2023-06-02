//
//  NCTextField.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit


final class NCTextField: UITextField {

		override init(frame: CGRect) {
				super.init(frame: frame)
				configure()
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


		private func configure() {
				translatesAutoresizingMaskIntoConstraints = false

				layer.cornerRadius = 10

				textColor = .label
				font = UIFont.preferredFont(forTextStyle: .body)
				tintColor = .label

				backgroundColor = .tertiarySystemBackground
				autocorrectionType = .yes

				returnKeyType = .send
				clearButtonMode = .never
		}

		
		let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)


		override public func textRect(forBounds bounds: CGRect) -> CGRect {
				return bounds.inset(by: padding)
		}

		override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
				return bounds.inset(by: padding)
		}

		override public func editingRect(forBounds bounds: CGRect) -> CGRect {
				return bounds.inset(by: padding)
		}
}
