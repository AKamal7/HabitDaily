//
//  AddHabitViewController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import UIKit

class AddHabitViewController: UIViewController {

    var editingHabit: Habit?
    var onSave: (() -> Void)? // Closure to call after saving
    let nameField = UITextField()
    let emojiField = UITextField()
    let frequencyField = UITextField()
    let reminderPicker = UIDatePicker()
    let frequencyPicker = UIPickerView()
    let frequencies = ["Daily", "Weekly", "Every 2 Days", "Every 3 Days", "Every 4 Days", "Every 5 Days", "Every 6 Days", "Every 2 Weeks", "Every Month"]
    let saveButton = UIButton(type: .system)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if editingHabit == nil {
            nameField.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = editingHabit == nil ? "Add Habit" : "Edit Habit"
        if let habit = editingHabit {
            nameField.text = habit.name
            emojiField.text = habit.emoji
            frequencyField.text = habit.frequency
            if let time = habit.reminderTime {
                reminderPicker.date = time
            }
            
            // Add Cancel button only when editing
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        }
        if editingHabit == nil {
            nameField.text = ""
            emojiField.text = ""
            frequencyField.text = ""
            reminderPicker.date = Date()
        }
        setupFields()
//        if let habit = editingHabit {
//            nameField.text = habit.name
//            emojiField.text = habit.emoji
//            frequencyField.text = habit.frequency
//            if let time = habit.reminderTime {
//                reminderPicker.date = time
//            }
//        }
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    func validateFields() -> Bool {
        var missingFields: [String] = []

        if nameField.text?.isEmpty ?? true {
            missingFields.append("Name")
        }
        if emojiField.text?.isEmpty ?? true {
            missingFields.append("Emoji")
        }
        if frequencyField.text?.isEmpty ?? true {
            missingFields.append("Frequency")
        }

        if !missingFields.isEmpty {
            let message = "The following field(s) are empty: \(missingFields.joined(separator: ", "))"
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return false
        }

        return true
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
        
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        frequencyField.inputView = frequencyPicker
        
        emojiField.delegate = self
        emojiField.placeholder = "Emoji"
//        emojiField.addTarget(self, action: #selector(showEmojiPicker), for: .editingDidBegin)
        emojiField.tintColor = .clear // Hide cursor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showEmojiPicker))
        emojiField.addGestureRecognizer(tapGesture)
        emojiField.isUserInteractionEnabled = true
        
        nameField.placeholder = "Habit Name"
        frequencyField.placeholder = "Frequency (e.g., Daily)"
        reminderPicker.datePickerMode = .time
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
//    @objc func showEmojiPicker() {
//        let emojiPicker = EmojiPickerViewController()
//        emojiPicker.delegate = self
//        emojiPicker.modalPresentationStyle = .popover
//        emojiPicker.preferredContentSize = CGSize(width: 300, height: 250)
//        
//        if let popover = emojiPicker.popoverPresentationController {
//            popover.sourceView = emojiField
//            popover.sourceRect = emojiField.bounds
//            popover.permittedArrowDirections = .up
//        }
//        
//        present(emojiPicker, animated: true)
//    }
    
    @objc func showEmojiPicker() {
        let emojiPicker = EmojiPickerViewController()
        emojiPicker.delegate = self
        emojiPicker.modalPresentationStyle = .popover
        if let popover = emojiPicker.popoverPresentationController {
            popover.sourceView = emojiField
            popover.sourceRect = emojiField.bounds
            popover.permittedArrowDirections = .up
            popover.delegate = self
        }
        present(emojiPicker, animated: true)
    }
    @objc func saveTapped() {
        guard validateFields() else { return }

        let context = CoreDataManager.shared.context
        let isNewHabit = (editingHabit == nil)
        let habit = editingHabit ?? Habit(context: context)

        habit.name = nameField.text
        habit.emoji = emojiField.text
        habit.frequency = frequencyField.text
        habit.reminderTime = reminderPicker.date
        habit.createdAt = habit.createdAt ?? Date()
        habit.isCompleted = false

        CoreDataManager.shared.saveContext()

        scheduleReminderNotification(
            for: nameField.text ?? "Your Habit",
            at: reminderPicker.date,
            withFrequency: frequencyField.text ?? "Daily"
        )

        onSave?()

        if isNewHabit {
            // Switch to "My Habits" tab
            tabBarController?.selectedIndex = 1

            // Clear fields for next habit
            nameField.text = ""
            emojiField.text = ""
            frequencyField.text = ""
            reminderPicker.date = Date()
        } else {
            // Dismiss if editing
            if navigationController?.presentingViewController != nil {
                dismiss(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }

//    @objc func saveTapped() {
//        guard validateFields() else { return }
//
//        let context = CoreDataManager.shared.context
//        let habit = editingHabit ?? Habit(context: context)
//
//        habit.name = nameField.text
//        habit.emoji = emojiField.text
//        habit.frequency = frequencyField.text
//        habit.reminderTime = reminderPicker.date
//        habit.createdAt = habit.createdAt ?? Date()
//        habit.isCompleted = false
//
//        CoreDataManager.shared.saveContext()
//
//        scheduleReminderNotification(
//            for: nameField.text ?? "Your Habit",
//            at: reminderPicker.date,
//            withFrequency: frequencyField.text ?? "Daily"
//        )
//
//        onSave?()
//
//        if navigationController?.presentingViewController != nil {
//            dismiss(animated: true) {
//                // 🔁 After dismissal, switch to "My Habits" tab
//                if let tabBar = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
//                    tabBar.selectedIndex = 1 // MyHabits tab index
//                }
//            }
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
    
    func scheduleReminderNotification(for habitName: String, at date: Date, withFrequency frequency: String) {
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        let emoji = emojiField.text ?? ""
        content.body = "Don't forget to complete your habit: \(emoji) \(habitName)"
        content.sound = .default

        let trigger: UNNotificationTrigger

        if frequency.lowercased() == "daily" {
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        } else if frequency.lowercased().contains("every") {
            let components = frequency.components(separatedBy: " ")
            
            if components.count >= 2, let interval = Int(components[1]) {
                if frequency.contains("day") {
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval * 86400), repeats: true)
                } else if frequency.contains("week") {
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval * 7 * 86400), repeats: true)
                } else if frequency.contains("month") {
                    // Approximate month as 30 days
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval * 30 * 86400), repeats: true)
                } else {
                    // Fallback to daily
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
                }
            } else {
                // Fallback if parsing fails
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
            }

        } else {
            // Fallback to non-repeating notification on selected date/time
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        }

        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(habitName) at \(date) with frequency: \(frequency)")
            }
        }
    }
    
    
//    func scheduleReminderNotification(for habitName: String, at date: Date) {
//        let content = UNMutableNotificationContent()
//        content.title = "Habit Reminder"
//        content.body = "Don't forget to complete your habit: \(habitName)"
//        content.sound = .default
//
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//        let identifier = UUID().uuidString // You can save this if you want to cancel later
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Failed to schedule notification: \(error)")
//            } else {
//                print("Notification scheduled for \(date)")
//            }
//        }
//    }

}

extension AddHabitViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequencyField.text = frequencies[row]
        frequencyField.resignFirstResponder()
    }
}

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emojiField {
            showEmojiPicker()
            return false
        }
        return true
    }
}

extension AddHabitViewController: EmojiPickerDelegate {
    func emojiPicker(_ picker: EmojiPickerViewController, didSelect emoji: String) {
        emojiField.text = emoji
    }
}

extension AddHabitViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // To make sure it stays as a popover on iPhone
    }
}
