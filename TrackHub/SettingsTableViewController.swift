//
//  SettingsTableViewController.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/14/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
    let settings = UserDefaults.standard
  
    var usernames: [String] = []
  
    // MARK: VC Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
      
      usernames = settings.array(forKey: "UserPrefs") as! [String]
      
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showNewUserAlertController))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell

        // Configure the cell...
        cell.nameLabel.text = usernames[indexPath.row]
        return cell
    }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
      
      self.usernames.remove(at: indexPath.row)
      self.settings.set(self.usernames, forKey: "UserPrefs")
      self.settings.synchronize()
      
      self.tableView.reloadData()
    })
    
    // You can set its properties like normal button
    deleteAction.backgroundColor = .red
    
    return [deleteAction]
  }
  

  
    // MARK: Alerts
  func showNewUserAlertController() {
    let alertController = UIAlertController(title: "New User", message: "Enter the Github username of the person you want to add:", preferredStyle: .alert)
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
      if let field = alertController.textFields![0].text {
        self.usernames += [field]
        self.settings.set(self.usernames, forKey: "UserPrefs")
        self.settings.synchronize()
        
        self.tableView.reloadData()
      } else {
        // user did not fill field
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Username"
    }
    
    alertController.addAction(confirmAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }

}
