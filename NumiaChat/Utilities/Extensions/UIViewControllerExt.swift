//
//  UIViewExt.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

extension UIViewController {

		func add(childVC: UIViewController, to containerView: UIView) {
				addChild(childVC)
				containerView.addSubview(childVC.view)
				childVC.view.frame = containerView.bounds
				childVC.didMove(toParent: self)
				containerView.layer.masksToBounds = true
		}


		func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
				DispatchQueue.main.async {
						guard self.presentedViewController == nil else {
								return
						}

						let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
						actions?.forEach { action in
								alertController.addAction(action)
						}


						self.present(alertController, animated: true)
				}
		}

		func hideKeyboardWhenTappedAround() {
				let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
				tap.cancelsTouchesInView = false
				view.addGestureRecognizer(tap)
		}

		@objc func dismissKeyboard() {
				view.endEditing(true)
		}
}
