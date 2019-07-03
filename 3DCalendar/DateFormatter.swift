//
//  DateFormatter.swift
//  3DCalendar
//
//  Created by Preston Brown on 7/3/19.
//  Copyright © 2019 Najia Haider. All rights reserved.
//

import Foundation

extension DateFormatter {

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static var singleDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()

    static var monthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}
