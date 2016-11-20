//
//  StreakRankingTableViewController.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/2/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class StreakRankingTableViewController: UITableViewController {
  
  var usernames: [String] = [] {
    didSet {
      getStreakData(names: usernames, completion: { streakData in
        self.streakData = streakData.sorted {$0.streak > $1.streak}
        
        self.tableView.reloadData()
      })
    }
  }
  
    let settings = UserDefaults.standard
  
  var streakData: [(name: String, streak: Int, barWidth: Float)] = []

    override func viewDidLoad() {
      super.viewDidLoad()
    }
  
    override func viewDidAppear(_ animated: Bool) {
      usernames = settings.array(forKey: "UserPrefs") as! [String]
    }
  
    // MARK: Data Aquisition
  
  func getStreakData(names: [String], completion: @escaping ([(name: String, streak: Int, barWidth: Float)]) -> Void) {
    var streakData: [(name: String, streak: Int, barWidth: Float)] = []
    var biggestStreak: Int = 0
      for name in names {
        NetworkHelper.getCurrentStreakFor(username: name, completion: { (currentStreak: Int) in
          var barWidth: Float = 0.0
          if name == names[0] {
            barWidth = 1.0
            biggestStreak = currentStreak
          } else if currentStreak > 0 {
            barWidth = Float(currentStreak) / Float(biggestStreak)
          }
          streakData += [(name: name, streak: currentStreak, barWidth: barWidth)]
          if streakData.count == names.count {
            completion(streakData)
          }
        })
      }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return self.streakData.count
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartTableViewCell
      
      let currentUser = streakData[indexPath.section]
      
      self.setupStreakCellInsetView(cell: cell, username: currentUser.name, barWidth: currentUser.barWidth, commits: currentUser.streak)
      return cell
    }
  
  fileprivate func setupStreakCellInsetView(cell: UITableViewCell, username: String, barWidth: Float, commits: Int) -> Void {
    let insetView = UIView(frame: CGRect(x: 10, y: 0, width: cell.contentView.frame.width - 20, height: cell.contentView.frame.height))
    insetView.backgroundColor = UIColor(white: 1, alpha: 0.4)
    insetView.layer.borderWidth = 2
    insetView.layer.borderColor = UIColor.lightGray.cgColor
    insetView.layer.cornerRadius = 10
    
    let barFrame = CGRect(x: 0, y: 0, width: Int(insetView.frame.width * CGFloat(barWidth)), height: Int(insetView.frame.height))
    let greenBarColor = UIColor(red: 164/255, green: 196/255, blue: 0/255, alpha: 0.7)
    insetView.addSubview(BarChartBarView(frame: barFrame, color: greenBarColor))
    
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
    nameLabel.font = UIFont(name: "Verdana", size: 16)
    nameLabel.text = username
    nameLabel.textAlignment = .center
    nameLabel.sizeToFit()
    nameLabel.center = insetView.convert(insetView.center, to: nameLabel)
    insetView.addSubview(nameLabel)
    
    let commitLabel = UILabel(frame: CGRect(x: 20, y: 0, width: insetView.frame.width - 40, height: insetView.frame.height))
    commitLabel.text = String(commits)
    commitLabel.textAlignment = .right
    commitLabel.font = UIFont(name: "Verdana", size: 32)
    commitLabel.textColor = .lightGray
    
    insetView.addSubview(commitLabel)
    cell.contentView.addSubview(insetView)
  }
}
