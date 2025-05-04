//
//  Date+.swift
//  FlashCard
//
//  Created by tientm on 22/12/2023.
//

import Foundation

extension Date {
    
    func toString(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
