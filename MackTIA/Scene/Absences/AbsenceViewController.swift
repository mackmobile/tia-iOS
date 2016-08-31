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
    func displayFetchedAbsences(viewModel: AbsenceViewModel.Success)
    func displayFetchedAbsencesError(viewModel: AbsenceViewModel.Error)
}

// Metodos que podem ser invocados no Interector
protocol AbsenceViewControllerOutput {
    func fetchAbsences(request: AbsenceRequest)
}

class AbsenceViewController: UITableViewController, AbsenceViewControllerInput {
    @IBOutlet weak var reloadButtonItem: UIBarButtonItem!
    var displayedAbsences:[Absence] = []
    
    // MARK: VIPER properties
    var output: AbsenceViewControllerOutput!
    var router: AbsenceRouter!
    
    // Interface Animation Parameters
    var selectedCellIndexPath:NSIndexPath?
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func configInterfaceAnimations() {
        self.refreshControl?.addTarget(self, action: #selector(AbsenceViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    private func startReloadAnimation() {
        reloadButtonItem.enabled = false
        self.navigationItem.title = "Carregando Faltas"
    }
    
    private func stopReloadAnimation() {
        reloadButtonItem.enabled = true
        refreshControl?.endRefreshing()
        self.navigationItem.title = "Faltas"
    }
    
    // MARK: Event handling
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.startReloadAnimation()
        let delayInSeconds = 1.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.fetchAbsences()
        }
    }
    
    func fetchAbsences() {
        self.startReloadAnimation()
        let request = AbsenceRequest()
        output.fetchAbsences(request)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        fetchAbsences()
    }
    
    // MARK: Display logic
    
    func displayFetchedAbsences(viewModel: AbsenceViewModel.Success) {
        self.stopReloadAnimation()
        displayedAbsences = viewModel.displayedAbsences
        tableView.reloadData()
    }
    
    func displayFetchedAbsencesError(viewModel: AbsenceViewModel.Error) {
        self.stopReloadAnimation()
        
        let alert = UIAlertController(title: viewModel.errorTitle, message: viewModel.errorMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = displayedAbsences.count
        
        if number == 0 {
            self.showEmptyMessage(NSLocalizedString("empty_table_absence", comment: "Sem faltas disponiveis"))
        }
        return number
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("faltaCell") as! AbsenceTableViewCell
        let absence = displayedAbsences[indexPath.row]
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != self.selectedCellIndexPath {
            self.selectedCellIndexPath = indexPath
        } else {
            if let _ = self.selectedCellIndexPath {
                self.tableView.deselectRowAtIndexPath(self.selectedCellIndexPath!, animated: true)
            }
            self.selectedCellIndexPath = nil
        }
        
        // Workaround haha quem fez?
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.selectedCellIndexPath == indexPath {
            return self.selectedCellHeight
        }
        return self.unselectedCellHeight
    }
    
    // MARK: UITableViewDelegate
}
