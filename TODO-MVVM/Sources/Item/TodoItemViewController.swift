//
//  TodoItemViewController.swift
//  TODO-MVVM
//
//  Created by Chen, Kai on 7/25/17.
//  Copyright © 2017 Chen, Kai. All rights reserved.
//

import UIKit

protocol TodoItemViewDelegate: class {

    func viewControllerDidSaveItem(_ viewController: TodoItemViewController)
}

class TodoItemViewController: UIViewController, UITextFieldDelegate {

    var viewModel: TodoItemViewModel!

    weak var delegate: TodoItemViewDelegate?

    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(save(_:)))

        datePicker.addTarget(self, action: #selector(pickerDidChange(_:)), for: .valueChanged)
        datePicker.minimumDate = viewModel.minimumDate
        dueDateLabel.text = viewModel.formattedDate

    }


    func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func save(_ sender: UIBarButtonItem) {

        if let title = titleTextField.text, let date = viewModel.selectedDate {
            viewModel.save(name: title, dueDate: date)
        }

        delegate?.viewControllerDidSaveItem(self)

        dismiss(animated: true, completion: nil)



    }

    func pickerDidChange(_ sender: UIDatePicker) {
        viewModel.selectedDate = datePicker.date
        dueDateLabel.text = viewModel.formattedDate
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
