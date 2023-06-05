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
		func findMessageInStorage(by id: UUID) -> MessageModel?
		func deleteMessage(by id: UUID)
}


final class CoreDataStorageManager: StorageManagerProtocol {

		let coreDataStack: CoreDataStack

		init(coreDataStack: CoreDataStack) {
				self.coreDataStack = coreDataStack
		}


		func saveToDataBase(new message: Message) {
				let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
				let newMessage = MessageModel(context: managedContext)
				newMessage.id = message.id
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
								Message(id: fetched.wrappedId, time: fetched.wrappedTime, text: fetched.wrappedText, avatarURL: fetched.wrappedAvatarURL)
						}

				} catch let error as NSError {
						print("Fetch error: \(error) description: \(error.userInfo)")
						throw ErrorMessage.unableFetchFromDataBase
				}

				return fetchedMessages
		}

		func findMessageInStorage(by id: UUID) -> MessageModel? {
				let request: NSFetchRequest<MessageModel> = MessageModel.fetchRequest()
				let predicate = NSPredicate(format: "id = %@", id as CVarArg)
				request.predicate = predicate

				do {
						let result = try coreDataStack.managedContext.fetch(request)
						print("FIND: \(result)")
						return result.first
				} catch {
						print("Fetch error: \(error) description: \(error.localizedDescription)")
						return nil
				}
		}

		func deleteMessage(by id: UUID) {
				let context = coreDataStack.managedContext
				if let message = findMessageInStorage(by: id) {
						context.delete(message)
						coreDataStack.saveContext()
				}
		}
}
