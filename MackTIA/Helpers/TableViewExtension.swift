//
//  TableViewExtension.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 28/08/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation
import UIKit

// MARK: String
extension UITableViewController {
    
    func showEmptyMessage(message:String) {
        let messageLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.5)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .Center;
        messageLabel.font = UIFont(name: "Bariol", size: 35)
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = .None;
    }
}
