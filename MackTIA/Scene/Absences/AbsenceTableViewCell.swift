//
//  AbsenceTableViewCell.swift
//  MackTIA
//
//  Created by Aleph Retamal on 4/18/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class AbsenceTableViewCell: UITableViewCell {

    @IBOutlet weak var aulasPrevistasLabel: UILabel!
    @IBOutlet weak var permitidasLabel: UILabel!
    @IBOutlet weak var faltasLabel: UILabel!
    @IBOutlet weak var nomeDaDisciplinaLabel: UILabel!

    @IBOutlet weak var progressBar: ProgressBarView!
    @IBOutlet weak var progressBarLabel: UILabel!
    
    @IBOutlet weak var atualizadoEmLabel: UILabel!
    
    @IBOutlet weak var circleGraph: CircleGraphView!
    @IBOutlet weak var circleProgressTotalLabel: UILabel!
    @IBOutlet weak var circleProgressLabel: UILabel!
    
    // TODO: FALTA LIGAR SÓ A VIEW
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
    }
}
