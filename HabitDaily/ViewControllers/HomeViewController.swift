//
//  HomeViewController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import UIKit
import UICircularProgressRing

class HomeViewController: UIViewController {

    @IBOutlet weak var progressMainView: UIView!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var habits: [Habit] = []
    
    override func viewDidLoad() {
         super.viewDidLoad()
         title = "Home"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habits = CoreDataManager.shared.fetchHabits()
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressRing.layer.cornerRadius = progressRing.frame.width / 2
        progressRing.clipsToBounds = true
//        progressRing.innerRingColor = .red
        progressRing.outerRingColor = .red

    }
    
    func updateProgressRing() {
        let habits = CoreDataManager.shared.fetchHabits()
        let total = habits.count
        let completed = habits.filter { $0.isCompletedToday() }.count

        let percentage = total == 0 ? 0 : (Double(completed) / Double(total)) * 100
        progressRing.startProgress(to: CGFloat(percentage), duration: 1.0)
        progressLabel.text = "\(completed)/\(total)"
    }
    
    private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "StreakTableViewCell", bundle: nil), forCellReuseIdentifier: "StreakCell")
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StreakCell", for: indexPath) as? StreakTableViewCell else {
            return UITableViewCell()
        }
        let habit = habits[indexPath.row]
        cell.configure(with: habit)
        return cell
    }
}
