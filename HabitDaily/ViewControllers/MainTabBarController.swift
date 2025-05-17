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
        
        viewControllers = [
            createNavController(storyboardID: "HomeViewController", title: "Home", image: UIImage(systemName: "house")!),
            createNavController(storyboardID: "MyHabitsViewController", title: "My Habits", image: UIImage(systemName: "list.bullet")!),
            createNavController(storyboardID: "AddHabitViewController", title: "Add Habit", image: UIImage(systemName: "plus.circle")!),
            createNavController(storyboardID: "StatisticsViewController", title: "Stats", image: UIImage(systemName: "chart.bar")!),
            createNavController(storyboardID: "SettingsViewController", title: "Settings", image: UIImage(systemName: "gear")!)
        ]
    }

    private func createNavController(storyboardID: String, title: String, image: UIImage) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        viewController.navigationItem.title = title
        return navController
    }
}
