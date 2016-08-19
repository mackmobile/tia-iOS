//
//  ScheduleTableViewCell.swift
//  MackTIA
//
//  Created by Luciano Moreira Turrini on 8/18/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var rangeTimeLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var collegeNameLabel: UILabel!
    @IBOutlet weak var buildingNumberLabel: UILabel?
    @IBOutlet weak var numberRoomLabel: UILabel?
    @IBOutlet weak var updatedAtLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
