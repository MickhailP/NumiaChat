//
//  ModuleBuilder.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 02.06.2023.
//

import UIKit


protocol Builder {
		func buildMainScreenModule() -> UIViewController
		func buildDetailMessageVC(with message: Message, delegate: DetailMessageScreenDelegate) -> UIViewController
}


final class ModuleBuilder: Builder {

		func buildMainScreenModule() -> UIViewController {

				let networkManager = NetworkManager()
				let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
				let storage = CoreDataStorageManager(coreDataStack: coreDataStack)

				let presenter = MainScreenPresenter(view: nil, networkingManager: networkManager, storageManager: storage)
				let vc = MainScreenViewController(presenter: presenter)
				presenter.view = vc
				return vc
		}

		func buildDetailMessageVC(with message: Message, delegate: DetailMessageScreenDelegate) -> UIViewController {
				let vc = DetailMessageVC(message: message)
				vc.delegate = delegate
				return vc
		}
}
