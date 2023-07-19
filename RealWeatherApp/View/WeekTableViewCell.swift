//
//  WeekTableViewCell.swift
//  RealWeatherApp
//
//  Created by jhchoi on 2023/07/10.
//

import UIKit

class WeekTableViewCell: UITableViewCell {

    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dayIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
