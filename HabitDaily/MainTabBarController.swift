//
//  MainTabBarController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let habitsVC = UINavigationController(rootViewController: MyHabitsViewController())
        habitsVC.tabBarItem = UITabBarItem(title: "My Habits", image: UIImage(systemName: "list.bullet"), tag: 1)

        let addHabitVC = UINavigationController(rootViewController: AddHabitViewController())
        addHabitVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.circle"), tag: 2)

        let statsVC = UINavigationController(rootViewController: StatisticsViewController())
        statsVC.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar"), tag: 3)
     let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)

        viewControllers = [homeVC, habitsVC, addHabitVC, statsVC, settingsVC]
    }
}
