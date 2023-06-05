//
//  MainScreenPresenter.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 02.06.2023.
//

import Foundation
import CoreData


//MARK: - MainScreenPresenterProtocol
protocol MainScreenPresenterProtocol: AnyObject & ChatTextfieldDelegate & DetailMessageScreenDelegate  {

		var messages: [Message] { get }

		var hasMoreMessages: Bool { get }
		var isLoading: Bool { get }
		var offset: Int { get }

		init(view: MainScreenProtocol?, networkingManager: NetworkProtocol, storageManager: StorageManagerProtocol)

		func fetchMessages(withScroll: ScrollOption)
		func getLocalMessagesFromDataBase()
}


//MARK: - MainScreenPresenter
final class MainScreenPresenter: MainScreenPresenterProtocol {

		private let networkingManager: NetworkProtocol
		private let storageManager: StorageManagerProtocol
		weak var view: MainScreenProtocol?

		private (set) var messages: [Message] = []
		private var localMessagesCount = 0

		private (set) var offset = 0
		private (set) var hasMoreMessages = true
		private (set) var isLoading = false


		init(view: MainScreenProtocol? = nil,
				 networkingManager: NetworkProtocol,
				 storageManager: StorageManagerProtocol) {
				self.view = view
				self.networkingManager = networkingManager
				self.storageManager = storageManager
		}



		func fetchMessages(withScroll: ScrollOption) {
				isLoading = true

				guard let url = Endpoint.getMessages(offset: offset).url else {
						view?.didFinishedFetchingWithError(message: ErrorMessage.badURl.rawValue)
						return
				}

				Task {
						let fetchedResult = await networkingManager.downloadDataResult(from: url)

						switch fetchedResult {
								case .success(let data):
										DispatchQueue.main.async {
												if let messages = self.decode(from: data) {

														self.messages.insert(contentsOf: messages.reversed(), at: 0)
														self.isLoading = false

														if messages.count == 0 {
																self.hasMoreMessages = false
														}

														self.view?.updateUI(with: messages, scrollOption: withScroll)
														self.offset += 1
												}
										}

								case .failure(let error):
										print(error)
										self.isLoading = false
										self.view?.didFinishedFetchingWithError(message: ErrorMessage.invalidData.rawValue)
						}
				}
		}


		private func decode(from data: Data) -> [Message]? {
				do {
						let decoded = try JSONDecoder().decode(MessageResponse.self, from: data)
						let messages = decoded.result.map { text in
								Message(id: UUID(), time: Date(), text: text, avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg")
						}
						return  messages

				} catch {
						print(error)

						self.isLoading = false
						view?.didFinishedFetchingWithError(message: ErrorMessage.decodingError.rawValue)
						return nil
				}
		}


		func getLocalMessagesFromDataBase() {

				do {
						let localMessages = try storageManager.getLocalMessagesFromDatabase()
						localMessagesCount = localMessages.count
						print(localMessagesCount)
						self.messages.insert(contentsOf: localMessages.reversed(), at: 0)
						view?.updateUI(with: localMessages, scrollOption: .bottom)
						
				} catch let error as ErrorMessage {
						view?.didFinishedFetchingWithError(message: error.rawValue)
				} catch {
						view?.didFinishedFetchingWithError(message: "Unknown error.")
				}
		}
}


//MARK: - ChatTextfieldDelegate
extension MainScreenPresenter: ChatTextfieldDelegate {

		func didTapSendButton(with message: String) {
				//SAVE DATA
				let newMessage = Message(id: UUID(), time: Date(), text: message, avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg")

				storageManager.saveToDataBase(new: newMessage)
				messages.append(newMessage)
				view?.sendNewMessage()
		}
}

//MARK: - DetailMessageScreenDelegate
extension MainScreenPresenter: DetailMessageScreenDelegate {

		func deleteMessageButtonPressed(for message: Message) {
				if let messageIndex = messages.firstIndex(of: message) {
						storageManager.deleteMessage(by: message.id)
						messages.remove(at: messageIndex)
						view?.updateUI(with: messages, scrollOption: .none)
				}
		}
}

