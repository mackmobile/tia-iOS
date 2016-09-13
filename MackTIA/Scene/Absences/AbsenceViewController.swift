//
//  AbsenceViewController.swift
//  MackTIA
//
//  Created by Aleph Retamal on 4/15/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// Metodos que poderao ser invocados pelo Presenter
protocol AbsenceViewControllerInput {
    func displayFetchedAbsences(_ viewModel: AbsenceViewModel.Success)
    func displayFetchedAbsencesError(_ viewModel: AbsenceViewModel.Error)
}

// Metodos que podem ser invocados no Interector
protocol AbsenceViewControllerOutput {
    func fetchAbsences(_ request: AbsenceRequest)
}

class AbsenceViewController: UITableViewController, AbsenceViewControllerInput {
    @IBOutlet weak var reloadButtonItem: UIBarButtonItem!
    var displayedAbsences:[Absence] = []
    
    // MARK: VIPER properties
    var output: AbsenceViewControllerOutput!
    var router: AbsenceRouter!
    
    // Interface Animation Parameters
    var selectedCellIndexPath:IndexPath?
    let selectedCellHeight:CGFloat = 150
    let unselectedCellHeight:CGFloat = 58
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AbsenceConfigurator.sharedInstance.configure(self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInterfaceAnimations()
        fetchAbsences()
    }
    
    // MARK: Interface Animations
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func configInterfaceAnimations() {
        self.refreshControl?.addTarget(self, action: #selector(AbsenceViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    fileprivate func startReloadAnimation() {
        reloadButtonItem.isEnabled = false
        self.navigationItem.title = "Carregando Faltas"
    }
    
    fileprivate func stopReloadAnimation() {
        reloadButtonItem.isEnabled = true
        refreshControl?.endRefreshing()
        self.navigationItem.title = "Faltas"
    }
    
    // MARK: Event handling
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.startReloadAnimation()
        let delayInSeconds = 1.0;
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.fetchAbsences()
        }
    }
    
    func fetchAbsences() {
        self.startReloadAnimation()
        let request = AbsenceRequest()
        output.fetchAbsences(request)
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        fetchAbsences()
    }
    
    // MARK: Display logic
    
    func displayFetchedAbsences(_ viewModel: AbsenceViewModel.Success) {
        self.stopReloadAnimation()
        displayedAbsences = viewModel.displayedAbsences
        tableView.reloadData()
    }
    
    func displayFetchedAbsencesError(_ viewModel: AbsenceViewModel.Error) {
        self.stopReloadAnimation()
        
        let alert = UIAlertController(title: viewModel.errorTitle, message: viewModel.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = displayedAbsences.count
        
        if number == 0 {
            self.showEmptyMessage(NSLocalizedString("empty_table_absence", comment: "Sem faltas disponiveis"))
        }
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "faltaCell") as! AbsenceTableViewCell
        let absence = displayedAbsences[(indexPath as NSIndexPath).row]
        
        cell.nomeDaDisciplinaLabel.text = absence.disciplina
        cell.faltasLabel.text = "\(absence.faltas)"
//        TODO: PREENCHER O RESTO DOS OUTLETS
        cell.aulasPrevistasLabel.text = "\(absence.dadas)"
        cell.permitidasLabel.text = "\(absence.permit)"
        cell.progressBarLabel.text = "\(absence.percentual)%"
        cell.atualizadoEmLabel.text = absence.atualizacao
        
        cell.progressBar.maxPercent = 25
        cell.progressBar.endPercent = CGFloat(absence.percentual)
        cell.circleGraph.endArc = CGFloat(absence.percentual/25)
        cell.circleProgressTotalLabel.text = "\(absence.percentual)%"
//        cell.circleProgressLabel.text =
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != self.selectedCellIndexPath {
            self.selectedCellIndexPath = indexPath
        } else {
            if let _ = self.selectedCellIndexPath {
                self.tableView.deselectRow(at: self.selectedCellIndexPath!, animated: true)
            }
            self.selectedCellIndexPath = nil
        }
        
        // Workaround haha quem fez?
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.selectedCellIndexPath == indexPath {
            return self.selectedCellHeight
        }
        return self.unselectedCellHeight
    }
    
    // MARK: UITableViewDelegate
}
