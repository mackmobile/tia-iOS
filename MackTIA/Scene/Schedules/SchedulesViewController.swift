//
//  SchedulesViewController.swift
//  MackTIA
//
//  Created by Luciano Moreira Turrini on 8/15/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SchedulesViewControllerInput {
    func displayFetchedSchedules(viewModel: SchedulesViewModel.Success)
    func displayFetchedSchedulesError(viewModel: SchedulesViewModel.Error)
}

protocol SchedulesViewControllerOutput {
    func fetchSchedules(request: SchedulesRequest)
}

class SchedulesViewController: UITableViewController, SchedulesViewControllerInput {
    
    // MARK: Outlets
    
    @IBOutlet weak var reloadButtonItem: UIBarButtonItem!
    
    // MARK: properties
    
    var headerView: ScheduleHeaderView?
    var segmentedControl: RS3DSegmentedControl!
    var displayedSchedules:[Schedule] = []
    var filteredSchedules = [Int:[Schedule]]()
    var keysW: [Int] = []
    let weekDays = [1 : "DOMINGO", 2 : "SEGUNDA", 3 : "TERÇA", 4 : "QUARTA", 5 : "QUINTA", 6 : "SEXTA" , 7 : "SÁBADO"]
    
    // MARK: VIPER properties
    var output: SchedulesViewControllerOutput!
    var router: SchedulesRouter!
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SchedulesConfigurator.sharedInstance.configure(self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHeaderView()
        self.setupSegmentedControl()
        self.setupHeightCell()
        self.configInterfaceAnimations()
        self.fetchSchedules()

    }
    
    // MARK: Interface Animations
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func setupHeightCell() -> Void {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
    func configInterfaceAnimations() {
        self.refreshControl?.addTarget(self, action: #selector(SchedulesViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    private func startReloadAnimation() {
        self.reloadButtonItem.enabled = false
        self.navigationItem.title = "Carregando Horários"
    }
    
    private func stopReloadAnimation() {
        reloadButtonItem.enabled = true
        refreshControl?.endRefreshing()
        self.navigationItem.title = "Horários"
    }
    
    private func setupHeaderView() -> Void {
        self.headerView = self.loadHeaderView()
    }
    
    private func loadHeaderView() -> ScheduleHeaderView? {
        let nibViews = NSBundle.mainBundle().loadNibNamed("ScheduleHeaderView", owner: self, options: nil)
        return nibViews.first as? ScheduleHeaderView
    }
    
    // MARK: Event handling
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.startReloadAnimation()
        let delayInSeconds = 1.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.fetchSchedules()
        }
    }
    
    func fetchSchedules() -> Void {
        self.startReloadAnimation()
        let request = SchedulesRequest()
        output.fetchSchedules(request)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        self.fetchSchedules()
    }
    
    // MARK: Display logic
    
    func displayFetchedSchedules(viewModel: SchedulesViewModel.Success) {
        self.stopReloadAnimation()
        filteredSchedules = viewModel.displayedSchedules
        if (filteredSchedules.count > 0) {
            self.segmentedControl.carousel.reloadData()
            tableView.reloadData()
        }
    }
    
    func displayFetchedSchedulesError(viewModel: SchedulesViewModel.Error) {
        self.stopReloadAnimation()
        
        let alert = UIAlertController(title: viewModel.errorTitle, message: viewModel.errorMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func dateScheduleFormatter(stringToParser: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = NSTimeZone(abbreviation: "BRST")
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        var stringDate: String?
        if let date = formatter.dateFromString(stringToParser) {
            formatter.dateFormat = "dd/MM/yyyy"
            stringDate = formatter.stringFromDate(date)
        }
        
        stringDate = stringDate ?? ""
        return stringDate!
    }
    
    // Usar para colocar o dia atual na Segmented
    private func getDay(date: NSDate) -> Int {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "BRST")
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        formatter.dateFormat = "dd"
        let string: String = formatter.stringFromDate(date)
        
        return Int(string)!
    }
    
}

// MARK: TableView Delegate Methods

extension SchedulesViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedSchedules.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let schedule = self.displayedSchedules[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("scheduleCell", forIndexPath: indexPath) as! ScheduleTableViewCell
        
        cell.disciplineLabel.text = schedule.discipline
        cell.rangeTimeLabel.text = schedule.rangeTime
        cell.classNameLabel.text = schedule.className
        cell.collegeNameLabel.text = schedule.collegeName
        cell.buildingNumberLabel?.text = schedule.buildingNumber
        cell.numberRoomLabel?.text = schedule.numberRoom
        if let updateAt = schedule.updatedAt {
            cell.updatedAtLabel?.text = "ATUALIZADO EM \(self.dateScheduleFormatter(updateAt))"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = self.headerView {
            return header
        }
        return nil
    }
    
}

// MARK: Segmented Control

extension SchedulesViewController: RS3DSegmentedControlDelegate {
    
    private func setupSegmentedControl() -> Void {
        self.segmentedControl = RS3DSegmentedControl(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        self.segmentedControl?.delegate = self
        self.headerView?.viewForSegmented.addSubview(segmentedControl)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl?.textFont = UIFont(name: "Bariol_Regular", size: 22)
        self.segmentedControl?.textColor = UIColor.redColor()
    }
    
    func numberOfSegmentsIn3DSegmentedControl(segmentedControl: RS3DSegmentedControl!) -> UInt {
        self.keysW = Array(filteredSchedules.keys)
        return UInt(filteredSchedules.count)
    }
    
    func titleForSegmentAtIndex(segmentIndex: UInt, segmentedControl: RS3DSegmentedControl!) -> String! {
        let day = weekDays[self.keysW[Int(segmentIndex)]]
        return day
    }
    
    func didSelectSegmentAtIndex(segmentIndex: UInt, segmentedControl: RS3DSegmentedControl!) {
        self.displayedSchedules = filteredSchedules[self.keysW[Int(segmentIndex)]]!
        self.tableView.reloadData()
    }
}