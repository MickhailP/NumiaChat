//
//  Message.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 01.06.2023.
//

import Foundation


struct Message: Hashable {
		let time: String
		let text: String
		let avatarURL: String

		static let examples: [Self] = [
				Message(time: "Сообщение 1", text: "Очень длинное сообщение 7, которое не помещается в одну строчку. Очень длинное сообщение 7, которое не помещается в одну строчку.", avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg"),
				Message(time: "Сообщение 2", text: "Очень длинное сообщение 7, которое не помещается в одну строчку. Очень длинное сообщение 7, которое не помещается в одну строчку.", avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg"),
				Message(time: "Сообщение 3", text: "Очень длинное сообщение 7, которое не помещается в одну строчку. Очень длинное сообщение 7, которое не помещается в одну строчку.", avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg"),
				Message(time: "Сообщение 3", text: "Сообщение 3", avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg"),
				Message(time: "Сообщение 5", text: "Очень длинное сообщение 7, которое не помещается в одну строчку. Очень длинное сообщение 7, которое не помещается в одну строчку.", avatarURL: "https://img5.cliparto.com/pic/s/206718/7326427-3d-cartoon-avatar-of-smiling-mature-man.jpg")
		]
}
