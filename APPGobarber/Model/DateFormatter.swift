//
//  DateFormatter.swift
//  APPGobarber
//
//  Created by MARCEL DIAZ GRANADOS ROBAYO on 2/06/24.
//

import Foundation
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}
