//
//  TodoListViewModel.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/25/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import Foundation

class TodoListViewModel {

    private let dataManager: TodoListDataManager

    var upcomings: UpcomingData

    let formatter: DateFormatter

    init(dataManager: TodoListDataManager) {
        self.dataManager = dataManager
        self.upcomings = UpcomingData(sections: [])
        self.formatter = DateFormatter()
    }


    func findUpcomingItems(completionHandler: @escaping (Void) -> Void) {

        let today = TodoDay()
        let end = today.endOfFollowingWeek

        dataManager.todoItems(from: today.date, to: end.date) { [weak self] items in

            guard let wself = self else {
                return
            }

            let sections = wself.groupingItems(with: items)
            wself.upcomings = UpcomingData(sections: sections)

            completionHandler()

        }

    }

    func groupingItems(with items: [TodoItem]) -> [UpcomingSection] {

        var groups: [NearTermDateRelation: [UpcomingItem]] = [:]

        items.forEach { item in

            let relation = nearTermRelation(from: item.dueDate)
            guard relation != .unknown else {
                return
            }
            let upcoming = UpcomingItem(title: item.name, dueDay: formatter.string(from: item.dueDate))

            if (groups[relation] == nil) {
                groups[relation] = [UpcomingItem]()
            }

            groups[relation]?.append(upcoming)
        }


        let sections: [UpcomingSection] = groups.keys.sorted().flatMap { key in
            guard let items = groups[key] else {
                return nil
            }
            return UpcomingSection(name: key.description, items: items)
        }

        return sections

    }

    func nearTermRelation(from: Date, to: Date = Date()) -> NearTermDateRelation {
        let today = TodoDay(date: to)
        let comparing = TodoDay(date: from)

        if (comparing < today) {
            return NearTermDateRelation.unknown
        } else if (today == comparing) {
            return NearTermDateRelation.today
        } else if (today.tomorrow == comparing) {
            return NearTermDateRelation.tomorrow
        } else if (today.isDuringSameWeek(as: comparing.date)) {
            return NearTermDateRelation.laterThisWeek
        } else if (today.endOfFollowingWeek.isDuringSameWeek(as: comparing.date)) {
            return NearTermDateRelation.nextWeek
        } else {
            return NearTermDateRelation.later
        }

    }


    struct UpcomingData {
        let sections: [UpcomingSection]

        subscript(indexPath: IndexPath) -> UpcomingItem? {
            if indexPath.section < sections.count && indexPath.row < sections[indexPath.section].items.count {
                return sections[indexPath.section].items[indexPath.row]
            } else {
                return nil
            }
        }
    }

    struct UpcomingSection {

        let name: String
        let items: [UpcomingItem]
    }

    struct UpcomingItem {

        let title: String
        let dueDay: String
    }

    enum NearTermDateRelation: Int, Comparable, CustomStringConvertible {
        case unknown
        case today
        case tomorrow
        case laterThisWeek
        case nextWeek
        case later


        public static func <(lhs: NearTermDateRelation, rhs: NearTermDateRelation) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

        public var description: String {
            switch self {
            case .today:
                return "Today"
            case .tomorrow:
                return "Tomorrow"
            case .laterThisWeek:
                return "This week"
            case .nextWeek:
                return "Next week"
            case .later:
                return "Later"
            case .unknown:
                return "Out of scope"
            }
        }
    }

}
