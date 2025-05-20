//
//  StreakTableViewCell.swift
//  HabitDaily
//
//  Created by ahmedkamal on 17/05/2025.
//

import UIKit

class StreakTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var streakLabel: UILabel!
      @IBOutlet weak var statusImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    
    func configure(with habit: Habit) {
        nameLabel.text = habit.name ?? "No Name"
        streakLabel.text = "🔥 \(habit.streakCount) Days"

        if habit.isCompletedToday() {
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            statusImageView.tintColor = .systemGreen
        } else {
            statusImageView.image = UIImage(systemName: "circle")
            statusImageView.tintColor = .black
        }
    }
    
}
