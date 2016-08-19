//
//  ScheduleHeaderView.swift
//  MackTIA
//
//  Created by Luciano Moreira Turrini on 8/18/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class ScheduleHeaderView: GSKStretchyHeaderView {

    @IBOutlet weak var viewForSegmented: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.expansionMode = .TopOnly;
    }
    
    override func didChangeStretchFactor(stretchFactor: CGFloat) {
        
    }

}
