//
//  HomeViewController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 11/05/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var progressMainView: UIView!
    @IBOutlet weak var progressCircularView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
         title = "Home"
//        setupTableView()
    }
    
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.dequeueReusableCell(withIdentifier: "StreakTableViewCell")
//    }
    
}

//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}
