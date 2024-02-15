//
//  CustomDateFormatter.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import Foundation

class CustomDateFormatter {
    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date string")
            return nil
        }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDateString = dateFormatter.string(from: date)
        
        return formattedDateString
    }
}
