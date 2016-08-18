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

protocol SchedulesViewControllerInput
{
  func displaySomething(viewModel: SchedulesViewModel)
}

protocol SchedulesViewControllerOutput
{
  func doSomething(request: SchedulesRequest)
}

class SchedulesViewController: UITableViewController, SchedulesViewControllerInput
{
  var output: SchedulesViewControllerOutput!
  var router: SchedulesRouter!
  
  // MARK: Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    SchedulesConfigurator.sharedInstance.configure(self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomethingOnLoad()
  }
  
  // MARK: Event handling
  
  func doSomethingOnLoad()
  {
    // NOTE: Ask the Interactor to do some work
    
    let request = SchedulesRequest()
    output.doSomething(request)
  }
  
  // MARK: Display logic
  
  func displaySomething(viewModel: SchedulesViewModel)
  {
    // NOTE: Display the result from the Presenter
    
    // nameTextField.text = viewModel.name
  }
}
