//
//  NCSendButton.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

class NCSendButton: UIButton {

		override init(frame: CGRect) {
				super.init(frame: frame)
				configure()
		}


		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}


		private func configure() {

				setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
				tintColor = .white
				titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
				translatesAutoresizingMaskIntoConstraints   = false
		}


		func set(backgroundColor: UIColor, title: String)  {
				self.backgroundColor = backgroundColor
				setTitle(title, for: .normal)
		}
}
