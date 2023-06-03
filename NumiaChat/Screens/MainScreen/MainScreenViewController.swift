//
//  MainScreenViewController.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

final class MainScreenViewController: UIViewController  {

		var presenter: MainScreenPresenterProtocol? 

		private var tableView = UITableView(frame: .zero, style: .plain)
		private var dataSource: UITableViewDiffableDataSource<Section, Message>?
		
		private let screenLabel = NCTitleLabel(textAlignment: .center, fontSize: 25)
		private let chatBarView = UIView()

		private let emptyStateView = EmptyView(message: "Seems the chat is empty. Try to send a message.")

		private var messages: [Message] = []

		var shouldScrollToBottom = true
		var lastCellIndex = 0
		
		override func viewDidLoad() {
				super.viewDidLoad()

				configureScreenLabel()
				configureTextFieldView()
				configureEmptyStateView()
				configureTableView()

				createDismissKeyboardTapGesture()
				configureDataSource()

				tableView.isHidden = true

				view.backgroundColor = .systemTeal

				presenter?.fetchMessages()

		}


		override func viewWillAppear(_ animated: Bool) {
				super.viewWillAppear(animated)
				navigationController?.isNavigationBarHidden = true
		}



}


//MARK: - TableView cells configuration
extension MainScreenViewController {

		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
				messages.count
		}


		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.messageCell, for: indexPath) as! MessageCell
				cell.setCell(with: messages[indexPath.row])

				return cell
		}
}



//MARK: - DataSource configuration
extension MainScreenViewController {

		enum Section: Hashable {
				case main
		}


		private func configureDataSource() {

				dataSource = UITableViewDiffableDataSource<Section, Message> (tableView: tableView, cellProvider: { tableView, indexPath, message in
						let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.messageCell, for: indexPath) as! MessageCell
						cell.setCell(with: message)
						return cell
				})
		}


		private func updateData(on messages: [Message]) {
				var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
				snapshot.appendSections([.main])
				snapshot.appendItems(messages, toSection: .main)

				DispatchQueue.main.async {
						guard let dataSource = self.dataSource else { return }
						dataSource.apply(snapshot, animatingDifferences: true)

				}
		}
}


//MARK: - MainScreenProtocol
extension MainScreenViewController: MainScreenProtocol {

		func updateUI(with messages: [Message]) {

				self.messages.insert(contentsOf: messages.reversed(), at: 0)

				if messages.isEmpty {
						self.presenter?.hasMoreMessages = false
						let action = UIAlertAction(title: "ok", style: .default)
						displayAlert(with: "Info", message: "There are not more messages", actions: [action])
						return
				}

				tableView.isHidden = false
				emptyStateView.isHidden = true

				updateData(on: self.messages)


				if shouldScrollToBottom {
						scrollToBottom()
				}
		}


		func send(new message: Message) {
				messages.append(message)
				self.updateData(on: self.messages)
				scrollToBottom()
		}


		func didFinishedFetchingWithError(message: String) {
				// SHOW ALERT
				let action = UIAlertAction(title: "Try again", style: .default) { _ in
						self.presenter?.fetchMessages()
				}
				displayAlert(with: "Error occurred", message: message, actions: [action])
		}
}



//MARK: - Pagination
extension MainScreenViewController: UITableViewDelegate {

		func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
				let position = scrollView.contentOffset.y

				if position < 100 {
						guard let presenter else { return }

						if presenter.hasMoreMessages, !presenter.isLoading {
								presenter.offset += 1
						print(lastCellIndex)
								presenter.fetchMessages()
								shouldScrollToBottom = false
						}
				}
		}


		private func scrollToBottom() {
				DispatchQueue.main.async {
						let bottomRow = IndexPath(row: self.messages.count - 1, section: 0)
						self.tableView.scrollToRow(at: bottomRow, at: .bottom, animated: true)
				}
		}
}


//MARK: - SubViews configurations

extension MainScreenViewController {
		private func configureScreenLabel() {
				view.addSubview(screenLabel)
				screenLabel.text = "Тестовое задание"
				screenLabel.textColor = .white

				NSLayoutConstraint.activate([
						screenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Paddings.padding10),
						screenLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.padding10),
						screenLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.padding10),
						screenLabel.heightAnchor.constraint(equalToConstant: 70)
				])
		}


		private func configureTableView() {

				tableView.register(MessageCell.self, forCellReuseIdentifier: CellIdentifiers.messageCell)
				tableView.separatorStyle = .none
				tableView.delegate = self

				view.addSubview(tableView)

				tableView.translatesAutoresizingMaskIntoConstraints = false

				NSLayoutConstraint.activate([
						tableView.topAnchor.constraint(equalTo: screenLabel.bottomAnchor),
						tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
						tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
						tableView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor)
				])
		}


		private func configureTextFieldView() {

				guard let presenter else { return }

				let textFieldVC = ChatTextfieldVC(delegate: presenter)
				add(childVC: textFieldVC, to: chatBarView)

				view.addSubview(chatBarView)
				chatBarView.translatesAutoresizingMaskIntoConstraints = false


				NSLayoutConstraint.activate([
						chatBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Paddings.padding10),
						chatBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.padding10),
						chatBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.padding10),
						chatBarView.heightAnchor.constraint(equalToConstant: 70)
				])
		}

		private func configureEmptyStateView() {
				view.addSubview(emptyStateView)


				NSLayoutConstraint.activate([
						emptyStateView.topAnchor.constraint(equalTo: screenLabel.bottomAnchor),
						emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
						emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
						emptyStateView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor)
				])
		}


		private func createDismissKeyboardTapGesture() {
				let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
				view.addGestureRecognizer(tap)
		}
}



//MARK: - Keyboard avoidance
//extension MainScreenViewController {
//		private func setNotificationForKeyboardAppearance() {
//				NotificationCenter.default.addObserver(
//						self,
//						selector: #selector(self.keyboardWillShow),
//						name: UIResponder.keyboardWillShowNotification,
//						object: nil)
//
//				NotificationCenter.default.addObserver(
//						self,
//						selector: #selector(self.keyboardWillHide),
//						name: UIResponder.keyboardWillHideNotification,
//						object: nil)
//		}
//
//		@objc func keyboardWillShow(_ notification: NSNotification) {
//				// Add code later...
//		}
//
//		@objc func keyboardWillHide(_ notification: NSNotification) {
//				// Add code later...
//		}
//}
