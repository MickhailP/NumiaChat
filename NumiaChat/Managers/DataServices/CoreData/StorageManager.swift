//
//  StorageManager.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 05.06.2023.
//

import Foundation
import CoreData


protocol StorageManagerProtocol {

		func saveToDataBase(new message: Message)
		func getLocalMessagesFromDatabase() throws -> [Message]
		func deleteMessage()
}


final class CoreDataStorageManager: StorageManagerProtocol {

		let coreDataStack: CoreDataStack

		init(coreDataStack: CoreDataStack) {
				self.coreDataStack = coreDataStack
		}


		func saveToDataBase(new message: Message) {
				let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
				let newMessage = MessageModel(context: managedContext)
				newMessage.time = Date()
				newMessage.text = message.text
				newMessage.avatarURL = message.avatarURL

				coreDataStack.saveContext()
		}

		func getLocalMessagesFromDatabase() throws -> [Message] {

				let messageFetch: NSFetchRequest<MessageModel> = MessageModel.fetchRequest()
				let sortByDate = NSSortDescriptor(key: #keyPath(MessageModel.time), ascending: false)
				messageFetch.sortDescriptors = [sortByDate]

				var fetchedMessages: [Message] = []

				do {
						let managedContext = coreDataStack.managedContext
						let results = try managedContext.fetch(messageFetch)

						fetchedMessages = results.map { fetched in
								Message(time: fetched.wrappedTime, text: fetched.wrappedText, avatarURL: fetched.wrappedAvatarURL)
						}

				} catch let error as NSError {
						print("Fetch error: \(error) description: \(error.userInfo)")
						throw ErrorMessage.unableFetchFromDataBase
				}

				return fetchedMessages
		}

		func deleteMessage() {
			
		}
}
