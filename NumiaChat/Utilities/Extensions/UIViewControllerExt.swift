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
}


//MARK: - Keyboard avoidance and hiding
extension UIViewController {

		func hideKeyboardWhenTappedAround() {
				let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
				tap.cancelsTouchesInView = false
				view.addGestureRecognizer(tap)
		}

		@objc func dismissKeyboard() {
				view.endEditing(true)
		}


		func setNotificationForKeyboardAppearance() {
				NotificationCenter.default.addObserver(
						self,
						selector: #selector(self.keyboardWillShow),
						name: UIResponder.keyboardWillShowNotification,
						object: nil)

				NotificationCenter.default.addObserver(
						self,
						selector: #selector(self.keyboardWillHide),
						name: UIResponder.keyboardWillHideNotification,
						object: nil)
		}

		func removeNotificationsForKeyboardAppearance() {
				NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
				NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		}


		@objc func keyboardWillShow(_ notification: NSNotification) {

		}

		@objc func keyboardWillHide(_ notification: NSNotification) {

		}


		func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool, action: (() -> Void)? = nil ) {

				guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else { return }

				let keyboardHeight = keyboardSize.cgRectValue.height

				let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
				let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!


				if keyboardWillShow {
						let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0)
						let bottomConstant: CGFloat = 20
						viewBottomConstraint.constant = -(keyboardHeight + (safeAreaExists ? 0 : bottomConstant))

						if let action {
								action()
						}

				} else {
						viewBottomConstraint.constant = -20
				}

				let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
						self?.view.layoutIfNeeded()
				}

				animator.startAnimation()
		}
}
