//
//  Message.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import Foundation


struct Message: Hashable {
		let time: Date
		let text: String
		let avatarURL: String
}
