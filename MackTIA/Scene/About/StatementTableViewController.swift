//
//  StatementTableViewController.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 28/08/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class StatementTableViewController: UITableViewController {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accept" {
            UserDefaults.standard.set("accepted", forKey: "statement")
        }
    }
}
