//
//  DateExt.swift
//  NumiaChat
//
//  Created by Миша Перевозчиков on 02.06.2023.
//

import Foundation


extension Date {

		func convertToHourMinutes() -> String {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "HH:mm"

				return dateFormatter.string(from: self)
		}
}
