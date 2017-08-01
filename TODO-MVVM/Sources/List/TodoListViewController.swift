//
//  TodoListViewController.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/25/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController {

    var viewModel: TodoListViewModel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MVVM TODO"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))

        tableView.dataSource = self
        tableView.delegate = self

        refresh()

    }

    func refresh(_ sender: UIBarButtonItem) {
        refresh()
    }

    func add(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "TodoAddSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "TodoAddSegue":

                if let navController = segue.destination as? UINavigationController,
                    let viewController = navController.viewControllers.first as? TodoItemViewController {

                    let dataManager = TodoAddDataManager(dataStore: CoreDataStore.shared)
                    let today = TodoDay().date
                    let viewModel = TodoItemViewModel(dataManager: dataManager, minimumDate: today)
                    viewController.viewModel = viewModel
                    viewController.delegate = self
                }

            default:
                return
            }
        }
    }

    fileprivate func refresh() {
        viewModel.findUpcomingItems { [unowned self] in
            self.tableView.reloadData()
        }
    }

}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.upcomings.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.upcomings.sections[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomings.sections[section].items.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)
        if let item = viewModel.upcomings[indexPath] {
            cell.textLabel?.text = item.title
        }

        return cell
    }

}

extension TodoListViewController: TodoItemViewDelegate {

    func viewControllerDidSaveItem(_ viewController: TodoItemViewController) {
        refresh()
    }
}
