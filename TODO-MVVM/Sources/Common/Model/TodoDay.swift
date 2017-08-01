//
//  TodoDay.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/26/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation

struct TodoDay {

    let date: Date
    fileprivate let calendar: Calendar

    init(date: Date = Date(), calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar
        self.date = calendar.startOfDay(for: date)
    }

}

extension TodoDay: CustomStringConvertible {

    var description: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .long
        formatter.timeZone = calendar.timeZone
        formatter.locale = calendar.locale

        return formatter.string(from: date)
    }
}

extension TodoDay: Equatable, Comparable {

    static func ==(lhs: TodoDay, rhs: TodoDay) -> Bool {
        return lhs.date == rhs.date
    }

    static func <(lhs: TodoDay, rhs: TodoDay) -> Bool {
        return lhs.date < rhs.date
    }
}

extension TodoDay {

    func nextDay(with offset: Int) -> TodoDay {
        var component = DateComponents()
        component.day = offset

        return TodoDay(date: calendar.date(byAdding: component, to: date)!,
                       calendar: calendar)
    }

    var tomorrow: TodoDay {
        return nextDay(with: 1)
    }

    var yesterday: TodoDay {
        return nextDay(with: -1)
    }

    var daysRemainingInWeek: Int {
        let components = calendar.dateComponents([.weekday], from: date)
        guard let range = calendar.range(of: .weekday, in: .weekOfYear, for: date),
            let weekday = components.weekday else {
            return 0
        }

        return range.count - weekday
    }

    var endOfWeek: TodoDay {
        return nextDay(with: daysRemainingInWeek)
    }

    var endOfFollowingWeek: TodoDay {
        var component = DateComponents()
        component.weekOfYear = 1

        return TodoDay(date: calendar.date(byAdding: component, to: endOfWeek.date)!,
                       calendar: calendar)
    }

    func isDuringSameWeek(as date: Date) -> Bool {
        return calendar.compare(self.date, to: date, toGranularity: .weekOfYear) == .orderedSame
    }

}
