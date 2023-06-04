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

    @NSManaged public var time: Date?
    @NSManaged public var text: String?
    @NSManaged public var avatarURL: String?

}

extension MessageModel : Identifiable {

}
