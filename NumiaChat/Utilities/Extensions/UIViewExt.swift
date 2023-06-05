//
//  UIViewExt.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 05.06.2023.
//

import UIKit

extension UIView {

		func pinToEdgesOf(view: UIView, constant: CGFloat) {
				NSLayoutConstraint.activate([
						topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
						leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
						trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
						bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant)
				])
		}
}
