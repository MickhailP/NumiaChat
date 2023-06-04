//
//  AppDelegate.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

		lazy var coreDataStack: CoreDataStack = .init(modelName: "Messages")


		static let sharedAppDelegate: AppDelegate = {
				guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
						fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
				}
				return delegate
		}()

		
		func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
				true
		}
		
		// MARK: UISceneSession Lifecycle
		
		func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
				UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
		}
		
		func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
				
		}
		
		
}

