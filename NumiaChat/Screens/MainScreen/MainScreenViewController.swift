//
//  MainScreenViewController.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import UIKit

final class MainScreenViewController: UIViewController  {


		private var tableView: UITableView?
		private var dataSource: UITableViewDiffableDataSource<Section, Message>?
		
		private let screenLabel = NCTitleLabel(textAlignment: .center, fontSize: 25)
		private let chatBarView = UIView()

		private var messages: [Message] = Message.examples

		
		override func viewDidLoad() {
				super.viewDidLoad()

				configureScreenLabel()
				configureTextFieldView()
				configureTableView()

				createDismissKeyboardTapGesture()
				configureDataSource()
				updateData(on: messages)
				
				view.backgroundColor = .systemTeal
		}


		override func viewWillAppear(_ animated: Bool) {
				super.viewWillAppear(animated)
				navigationController?.isNavigationBarHidden = true
		}
		
		
		
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
				tableView = UITableView(frame: view.bounds, style: .plain)
				guard let tableView else { return }

				tableView.register(MessageCell.self, forCellReuseIdentifier: CellIdentifiers.messageCell)
				tableView.separatorStyle = .none

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

				let textFieldVC = ChatTextfieldVC(delegate: self)
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

		
		private func createDismissKeyboardTapGesture(){
				let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
				view.addGestureRecognizer(tap)
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
				guard let tableView else { return }

				dataSource = UITableViewDiffableDataSource<Section, Message> (tableView: tableView, cellProvider: { tableView, indexPath, message in
						let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.messageCell, for: indexPath) as! MessageCell
						cell.setCell(with: message)
						return cell
				})
		}


		private func updateData(on messages: [Message]) {
				var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
				snapshot.appendSections([.main])
				snapshot.appendItems(messages)

				DispatchQueue.main.async {
						guard let dataSource = self.dataSource else { return }
						dataSource.apply(snapshot)
				}
		}
}


//MARK: - ChatTextfieldDelegate
extension MainScreenViewController: ChatTextfieldDelegate {

		func didTapSendButton(with message: String) {
				print("feleate")
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
