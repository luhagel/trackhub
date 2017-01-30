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
        return self.usernames.count
    }
  

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView()
      headerView.backgroundColor = .clear
      return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
      
        cell.backgroundColor = .clear

        // Configure the cell...
        cell.nameLabel.text = usernames[indexPath.section]
        cell.nameLabel.textColor = .white
        return cell
    }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
      
      self.usernames.remove(at: indexPath.section)
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
        NetworkHelper.checkStatusCode(name: field) { status in
          if status == 200 {
            self.usernames += [field]
            self.settings.set(self.usernames, forKey: "UserPrefs")
            self.settings.synchronize()
            
            self.tableView.reloadData()
          } else {
            let errorAlert = UIAlertController(title: "User no found", message: "Maybe you have a typo?", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(errorAlert, animated: true, completion: nil)
          }
        }
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
