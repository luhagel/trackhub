//
//  StreakRankingTableViewController.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/2/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class StreakRankingTableViewController: UITableViewController {
  
    let usernames = [
      "luhagel",
      "jakezeal",
      "fanisakim",
      "ajbraus",
      "davidkc0"
    ]
  
    var streakData: [(name: String, streak: Int)] = []

    override func viewDidLoad() {
      super.viewDidLoad()
      
      let backgroundImage = UIImage(named: "tracker_bg")
      let backgroundView = UIImageView(image: backgroundImage)
      self.tableView.backgroundView = backgroundView
      self.tableView.backgroundView?.contentMode = .scaleAspectFill

      getStreakData(names: usernames, completion: { streakData in
        self.streakData = streakData.sorted {$0.streak > $1.streak}
        self.tableView.reloadData()
      })
    }
  
    // MARK: Data Aquisition
  
    func getStreakData(names: [String], completion: @escaping ([(name: String, streak: Int)]) -> Void) {
      var streakData: [(name: String, streak: Int)] = []
      for name in names {
        NetworkHelper.getCurrentStreakFor(username: name, completion: { currentStreak in
          streakData += [(name: name, streak: currentStreak)]
          if streakData.count == names.count {
            completion(streakData)
          }
        })
      }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return self.streakData.count
    }
  
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 10
    }
  
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView()
      headerView.backgroundColor = UIColor.clear
      return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartTableViewCell
      let currentUser = streakData[indexPath.section]
      let barFrame = CGRect(x: 5, y: 5, width: 200, height: 20)
      
      let insetView = UIView(frame: CGRect(x: 10, y: 0, width: cell.contentView.frame.width - 20, height: cell.contentView.frame.height))
      insetView.backgroundColor = UIColor(white: 1, alpha: 0.8)
      insetView.layer.cornerRadius = 5
      
      let greenBarColor = UIColor(red: 30/255, green: 104/255, blue: 35/255, alpha: 0.9)
      insetView.addSubview(BarChartBarView(frame: barFrame, color: greenBarColor, username: currentUser.name, commits: currentUser.streak))
      
      cell.contentView.addSubview(insetView)
      return cell
    }
}
