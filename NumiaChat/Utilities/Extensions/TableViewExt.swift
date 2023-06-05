//
//  TableViewExt.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 05.06.2023.
//

import UIKit


extension UITableView {

		func scrollToBottom(to row: Int, in section: Int = 0) {
				DispatchQueue.main.async {
						let bottomRow = IndexPath(row: row, section: section)
						self.scrollToRow(at: bottomRow, at: .top, animated: true)
				}
		}

		func stayAtCell(to row: Int, in section: Int = 0) {
				DispatchQueue.main.async {
						let current = IndexPath(row: row, section: section)
						print("ROW: \(current)")
						self.scrollToRow(at: current, at: .top, animated: false)
				}
		}
}
