//
//  ModuleBuilder.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 02.06.2023.
//

import UIKit


protocol Builder {
		func buildMainScreenModule() -> UIViewController
}


final class ModuleBuilder: Builder {

		func buildMainScreenModule() -> UIViewController {
				let vc = MainScreenViewController()
				let presenter = MainScreenPresenter(view: vc, networkingManager: NetworkManager())
				vc.presenter = presenter
				return vc
		}

		func buildDetailMessageVC(with message: Message) -> UIViewController {
				DetailMessageVC(message: message)
		}
}
