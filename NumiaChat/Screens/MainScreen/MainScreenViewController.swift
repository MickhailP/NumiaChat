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

		var chatViewBottomConstraint: NSLayoutConstraint?
		
		override func viewDidLoad() {
				super.viewDidLoad()

				view.backgroundColor = .systemTeal

				configureScreenLabel()
				configureChatBarView()
				configureEmptyStateView()
				configureTableView()

				hideKeyboardWhenTappedAround()
				configureDataSource()

				setNotificationForKeyboardAppearance()

				presenter?.getLocalMessagesFromDataBase()
				presenter?.fetchMessages()
		}


		override func viewWillAppear(_ animated: Bool) {
				super.viewWillAppear(animated)

		}

		override func viewDidAppear(_ animated: Bool) {
				super.viewDidAppear(animated)
				navigationController?.isNavigationBarHidden = true
		}

		override func viewWillDisappear(_ animated: Bool) {
				super.viewWillDisappear(animated)
				removeNotificationsForKeyboardAppearance()
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
						dataSource.apply(snapshot, animatingDifferences: false)

				}
		}
}


//MARK: - MainScreenProtocol
extension MainScreenViewController: MainScreenProtocol {

		func updateUI(with messages: [Message]) {

				lastCellIndex = messages.count

				self.messages.insert(contentsOf: messages.reversed(), at: 0)

				if messages.isEmpty {
						let action = UIAlertAction(title: "ok", style: .default)
						displayAlert(with: "Info", message: "There are not more messages", actions: [action])
						return
				}

				tableView.isHidden = false
				emptyStateView.isHidden = true
				updateData(on: self.messages)

				if shouldScrollToBottom {
						scrollToBottom()
				} else {
						stayAtCell()
				}
		}


		func send(new message: Message) {
				messages.append(message)
				updateData(on: self.messages)
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


//MARK: - Pagination, Scrolling
extension MainScreenViewController {

		func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
				let position = scrollView.contentOffset.y

				if position < 100 {
						guard let presenter else { return }

						if presenter.hasMoreMessages, !presenter.isLoading {
								presenter.fetchMessages()
								shouldScrollToBottom = false
						}
				}
		}


		private func scrollToBottom() {
				DispatchQueue.main.async {
						let bottomRow = IndexPath(row: self.messages.count - 1, section: 0)
						self.tableView.scrollToRow(at: bottomRow, at: .top, animated: true)
				}
		}

		private func stayAtCell() {
				DispatchQueue.main.async {

						let current = IndexPath(row: self.lastCellIndex - 1, section: 0)
						print("ROW: \(current)")
						self.tableView.scrollToRow(at: current, at: .top, animated: false)
				}
		}
}


//MARK: - UITableViewDelegate
extension MainScreenViewController: UITableViewDelegate {

		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
				let message = messages[indexPath.row]

				let destVC = ModuleBuilder().buildDetailMessageVC(with: message)
				navigationController?.pushViewController(destVC, animated: true)
		}
}


//MARK: - Subviews configurations
extension MainScreenViewController {

		private func configureScreenLabel() {
				view.addSubview(screenLabel)
				screenLabel.text = "Тестовое задание"
				screenLabel.textColor = .white

				NSLayoutConstraint.activate([
						screenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Paddings.padding10),
						screenLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.padding10),
						screenLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.padding10),
						screenLabel.heightAnchor.constraint(equalToConstant: 50)
				])
		}


		private func configureTableView() {

				tableView.register(MessageCell.self, forCellReuseIdentifier: CellIdentifiers.messageCell)
				tableView.separatorStyle = .none
				tableView.delegate = self
				tableView.isHidden = true
				view.addSubview(tableView)

				tableView.translatesAutoresizingMaskIntoConstraints = false


				NSLayoutConstraint.activate([
						tableView.topAnchor.constraint(equalTo: screenLabel.bottomAnchor),
						tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
						tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
						tableView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor)
				])
		}


		private func configureChatBarView() {

				guard let presenter else { return }

				let textFieldVC = ChatTextfieldVC(delegate: presenter)
				add(childVC: textFieldVC, to: chatBarView)

				view.addSubview(chatBarView)
				chatBarView.translatesAutoresizingMaskIntoConstraints = false

				chatViewBottomConstraint = chatBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Paddings.padding10)

				NSLayoutConstraint.activate([
						chatBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.padding10),
						chatBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.padding10),
						chatViewBottomConstraint!,
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
}



//MARK: - Keyboard avoidance
extension MainScreenViewController {

		@objc override func keyboardWillShow(_ notification: NSNotification) {
					if let chatViewBottomConstraint	{
						moveViewWithKeyboard(notification: notification, viewBottomConstraint: chatViewBottomConstraint, keyboardWillShow: true, action: scrollToBottom)
				}
		}


		@objc override func keyboardWillHide(_ notification: NSNotification) {
				if let chatViewBottomConstraint{
						moveViewWithKeyboard(notification: notification, viewBottomConstraint: chatViewBottomConstraint, keyboardWillShow: false)
				}
		}
}
