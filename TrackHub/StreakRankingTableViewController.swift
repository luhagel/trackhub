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
  
    var streakData: [(name: String, streak: Int)] = []

    override func viewDidLoad() {
      super.viewDidLoad()
      
      let backgroundImage = UIImage(named: "tracker_bg")
      let backgroundView = UIImageView(image: backgroundImage)
      self.tableView.backgroundView = backgroundView
      self.tableView.backgroundView?.contentMode = .scaleAspectFill
    }
  
    override func viewDidAppear(_ animated: Bool) {
      usernames = settings.array(forKey: "UserPrefs") as! [String]
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
      return self.streakData.count
    }
  
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 10
    }
  
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
      
      let insetView = UIView(frame: CGRect(x: 10, y: 0, width: cell.contentView.frame.width - 20, height: cell.contentView.frame.height))
      insetView.backgroundColor = UIColor(white: 1, alpha: 0.8)
      insetView.layer.cornerRadius = 5
      
      let currentUser = streakData[indexPath.section]
      let nameLabel = UILabel(frame: CGRect(x: 5, y: 3, width: 100, height: 25))
      nameLabel.text = currentUser.name
      nameLabel.sizeToFit()
      insetView.addSubview(nameLabel)
      
      let barFrame = CGRect(x: 5, y: 28, width: 10 + currentUser.streak * 10, height: 20)
      let greenBarColor = UIColor(red: 30/255, green: 104/255, blue: 35/255, alpha: 0.9)
      insetView.addSubview(BarChartBarView(frame: barFrame, color: greenBarColor, username: currentUser.name, commits: currentUser.streak))
      
      cell.contentView.addSubview(insetView)
      return cell
    }
}
