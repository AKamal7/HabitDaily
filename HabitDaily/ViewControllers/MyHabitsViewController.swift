//
//  MyHabitsViewController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import UIKit

class MyHabitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var habits: [Habit] = []
       let tableView = UITableView()
    
       override func viewDidLoad() {
           super.viewDidLoad()
           title = "My Habits"
           view.backgroundColor = .systemBackground

           tableView.dataSource = self
           tableView.delegate = self
           view.addSubview(tableView)
           tableView.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])

       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHabits()

    }

       func loadHabits() {
           habits = CoreDataManager.shared.fetchHabits()
           tableView.reloadData()
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return habits.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
           let habit = habits[indexPath.row]
           cell.textLabel?.text = "\(habit.emoji ?? "") \(habit.name ?? "")"
           cell.detailTextLabel?.text = "Frequency: \(habit.frequency ?? "")"
           return cell
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        let vc = AddHabitViewController()
        vc.editingHabit = habit
        vc.onSave = { [weak self] in
            self?.loadHabits()
        }

        let navVC = UINavigationController(rootViewController: vc)
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        present(navVC, animated: true)
    }

}
