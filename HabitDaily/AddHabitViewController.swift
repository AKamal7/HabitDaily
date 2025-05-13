//
//  AddHabitViewController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import UIKit

class AddHabitViewController: UIViewController {

    var editingHabit: Habit?

    let nameField = UITextField()
    let emojiField = UITextField()
    let frequencyField = UITextField()
    let reminderPicker = UIDatePicker()
    let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = editingHabit == nil ? "Add Habit" : "Edit Habit"

        setupFields()
        if let habit = editingHabit {
            nameField.text = habit.name
            emojiField.text = habit.emoji
            frequencyField.text = habit.frequency
            if let time = habit.reminderTime {
                reminderPicker.date = time
            }
        }
    }

    func setupFields() {
        let stack = UIStackView(arrangedSubviews: [nameField, emojiField, frequencyField, reminderPicker, saveButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        nameField.placeholder = "Habit Name"
        emojiField.placeholder = "Emoji"
        frequencyField.placeholder = "Frequency (e.g., Daily)"
        reminderPicker.datePickerMode = .time
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc func saveTapped() {
        let context = CoreDataManager.shared.context
        let habit = editingHabit ?? Habit(context: context)

        habit.name = nameField.text
        habit.emoji = emojiField.text
        habit.frequency = frequencyField.text
        habit.reminderTime = reminderPicker.date
        habit.createdAt = habit.createdAt ?? Date()
        habit.isCompleted = false

        CoreDataManager.shared.saveContext()
        if let editingHabit {
            navigationController?.popViewController(animated: true)

        } else {
            tabBarController?.selectedIndex = 1
        }
    }

}
