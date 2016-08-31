//
//  StatementTableViewController.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 28/08/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class StatementTableViewController: UITableViewController {
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accept" {
            NSUserDefaults.standardUserDefaults().setObject("accepted", forKey: "statement")
        }
    }
}
