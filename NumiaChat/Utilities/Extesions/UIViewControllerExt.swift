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

}
