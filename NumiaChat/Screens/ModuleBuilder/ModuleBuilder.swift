//
//  ModuleBuilder.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 02.06.2023.
//

import UIKit


protocol Builder {
		func buildMainScreenModule() -> UIViewController
		func buildDetailMessageVC(with message: Message) -> UIViewController
}


final class ModuleBuilder: Builder {

		func buildMainScreenModule() -> UIViewController {
				let vc = MainScreenViewController()
				let networkManager = NetworkManager()
				let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
				let storage = CoreDataStorageManager(coreDataStack: coreDataStack)

				let presenter = MainScreenPresenter(view: vc, networkingManager: networkManager, storageManager: storage)
				vc.presenter = presenter
				return vc
		}

		func buildDetailMessageVC(with message: Message) -> UIViewController {
				DetailMessageVC(message: message)
		}
}
