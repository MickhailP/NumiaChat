//
//  MainScreenViewController.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

//MARK: - MainScreenProtocol
protocol MainScreenProtocol: AnyObject {

		func updateUI(with messages: [Message], scrollOption: ScrollOption)
		func sendNewMessage()
		func didFinishedFetchingWithError(message: String)
}



//MARK: - MainScreenViewController
final class MainScreenViewController: UIViewController  {
		
		var presenter: MainScreenPresenterProtocol
		var lastCellIndex = 0
		
		private var tableView = UITableView(frame: .zero, style: .plain)
		private var dataSource: UITableViewDiffableDataSource<Section, Message>?
		
		private let screenLabel = NCTitleLabel(textAlignment: .center, fontSize: 25)
		private let chatBarView = UIView()
		private let emptyStateView = EmptyView(message: "Seems the chat is empty. Try to send a message.")
		private let loadingView = NCDataLoadingView(frame: .zero)
		
		var chatViewBottomConstraint: NSLayoutConstraint?

		
		init(presenter: MainScreenPresenterProtocol) {
				self.presenter = presenter
				super.init(nibName: nil, bundle: nil)
		}

		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}

		
		override func viewDidLoad() {
				super.viewDidLoad()

				view.backgroundColor = .systemTeal

				configureSubviews()
				configureDataSource()

				hideKeyboardWhenTappedAround()
				setNotificationForKeyboardAppearance()

				presenter.getLocalMessagesFromDataBase()
				presenter.fetchMessages(withScroll: .bottom)
		}


		override func viewWillAppear(_ animated: Bool) {
				super.viewWillAppear(animated)
				navigationController?.setNavigationBarHidden(true, animated: animated)
		}


		override func viewWillDisappear(_ animated: Bool) {
				super.viewWillDisappear(animated)
				removeNotificationsForKeyboardAppearance()
		}
}


//MARK: - TableView cells configuration
extension MainScreenViewController {

		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
				presenter.messages.count
		}


		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.messageCell, for: indexPath) as! MessageCell
				cell.setCell(with: presenter.messages[indexPath.row])
				return cell
		}
}


//MARK: - UITableViewDelegate
extension MainScreenViewController: UITableViewDelegate {

		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
				let message = presenter.messages[indexPath.row]

				let destVC = ModuleBuilder().buildDetailMessageVC(with: message, delegate: presenter)
				navigationController?.pushViewController(destVC, animated: true)
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

		func updateUI(with messages: [Message],	scrollOption: ScrollOption) {

				lastCellIndex = messages.count

				if messages.isEmpty {
						let action = UIAlertAction(title: "ok", style: .default)
						displayAlert(with: "Info", message: "There are not more messages", actions: [action])
						return
				}

				tableView.isHidden = false
				emptyStateView.isHidden = true
				loadingView.isHidden = true
				updateData(on: self.presenter.messages)

				switch scrollOption {
						case.bottom:
								tableView.scrollToBottom(to: self.presenter.messages.count - 1, in: 0)
						case.stay:
								tableView.stayAtCell(to: self.lastCellIndex - 1, in: 0)
						case .none:
								return
				}
		}


		func sendNewMessage() {
				updateData(on: self.presenter.messages)
				tableView.scrollToBottom(to: self.presenter.messages.count - 1)
		}


		func didFinishedFetchingWithError(message: String) {
				let action = UIAlertAction(title: "Try again", style: .default) { _ in
						self.presenter.fetchMessages(withScroll: .bottom)
				}
				displayAlert(with: "Error occurred", message: message, actions: [action])
		}
}


//MARK: - Pagination, Scrolling
extension MainScreenViewController {

		func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
				let position = scrollView.contentOffset.y

				if position < 100 {
						if presenter.hasMoreMessages, !presenter.isLoading {
								presenter.fetchMessages(withScroll: .stay)
								loadingView.isHidden = false
						}
				}
		}
}


//MARK: - Subviews configurations
extension MainScreenViewController {

		private func configureSubviews() {
				configureScreenLabel()
				configureChatBarView()
				configureEmptyStateView()
				configureTableView()
				configureLoadingView()
		}

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

		private func configureLoadingView() {
				view.addSubview(loadingView)
				loadingView.isHidden = true

				NSLayoutConstraint.activate([
						loadingView.topAnchor.constraint(equalTo: screenLabel.bottomAnchor),
						loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
						loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
						loadingView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor)
				])
		}
}



//MARK: - Keyboard avoidance
extension MainScreenViewController {

		private func scrollWhenKeyboardShows() {
				tableView.scrollToBottom(to: self.presenter.messages.count - 1)
		}

		@objc override func keyboardWillShow(_ notification: NSNotification) {
					if let chatViewBottomConstraint	{
							moveViewWithKeyboard(notification: notification, viewBottomConstraint: chatViewBottomConstraint, keyboardWillShow: true, action: scrollWhenKeyboardShows)
				}
		}


		@objc override func keyboardWillHide(_ notification: NSNotification) {
				if let chatViewBottomConstraint{
						moveViewWithKeyboard(notification: notification, viewBottomConstraint: chatViewBottomConstraint, keyboardWillShow: false)
				}
		}
}
