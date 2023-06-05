//
//  MessageModel+CoreDataProperties.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 04.06.2023.
//
//

import Foundation
import CoreData
import UIKit


extension MessageModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageModel> {
        return NSFetchRequest<MessageModel>(entityName: "MessageModel")
    }
		@NSManaged public var id: UUID?
    @NSManaged public var time: Date?
    @NSManaged public var text: String?
    @NSManaged public var avatarURL: String?

		var wrappedId: UUID {
				id ?? UUID()
		}

		var wrappedTime: Date {
				time ?? Date()
		}

		var wrappedText: String {
				text ?? "Unknown"
		}

		var wrappedAvatarURL: String {
				avatarURL ?? "Unknown"
		}

}

extension MessageModel : Identifiable {

}
