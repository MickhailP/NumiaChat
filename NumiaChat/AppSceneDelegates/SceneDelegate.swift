//
//  SceneDelegate.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let mainVC = ModuleBuilder.buildMainScreenModule()
		let navVC = UINavigationController(rootViewController: mainVC)
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		window?.rootViewController = navVC
		window?.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {

	}

	func sceneDidBecomeActive(_ scene: UIScene) {

	}

	func sceneWillResignActive(_ scene: UIScene) {

	}

	func sceneWillEnterForeground(_ scene: UIScene) {

	}

	func sceneDidEnterBackground(_ scene: UIScene) {

	}
}

