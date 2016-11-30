//
//  StreakRankingTableViewController.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/2/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import AlamofireImage

class StreakRankingTableViewController: UITableViewController {
  
  let settings = UserDefaults.standard
  
  var usernames: [String] = [] {
    didSet {
      getStreakData(names: usernames, completion: { streakData in
        self.streakData = streakData.sorted {$0.streak > $1.streak}
      })
    }
  }
  
  var streakData: [(name: String, streak: Int)] = [] {
    didSet {
      highscoreList = []
      var biggestStreak = 0
      for tracked in streakData {
        var barWidth: Float = 0.0
        if tracked.name == streakData[0].name {
          barWidth = 1.0
          biggestStreak = tracked.streak
        } else if tracked.streak > 0 {
          barWidth = Float(tracked.streak) / Float(biggestStreak)
        }
        highscoreList += [(name: tracked.name, streak: tracked.streak, barWidth: barWidth)]
      }
      self.tableView.reloadData()
    }
  }
  
  var highscoreList: [(name: String, streak: Int, barWidth: Float)] = []

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    usernames = settings.array(forKey: "UserPrefs") as! [String]
  }

  // MARK: Data Aquisition
  
  func getStreakData(names: [String], completion: @escaping ([(name: String, streak: Int)]) -> Void) {
    var streakData: [(name: String, streak: Int)] = []
      for name in names {
        NetworkHelper.getCurrentStreakFor(username: name, completion: { (currentStreak: Int) in
          streakData += [(name: name, streak: currentStreak)]
          if streakData.count == names.count {
            completion(streakData)
          }
        })
      }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView()
      headerView.backgroundColor = .clear
      return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.highscoreList.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartTableViewCell
      
      let currentUser = highscoreList[indexPath.row]
      
      let barFrame = CGRect(x: 80, y: Int(cell.contentView.frame.height - 12), width: Int((cell.contentView.frame.width - 100) * CGFloat(currentUser.barWidth)), height: 4)
      cell.contentView.addSubview(BarChartBarView(frame: barFrame, color: .orange))
      
      let nameLabel = UILabel(frame: CGRect(x: 80, y: 8, width: 100, height: 25))
      nameLabel.font = UIFont(name: "Verdana", size: 18)
      nameLabel.textColor = .white
      nameLabel.text = currentUser.name
      nameLabel.textAlignment = .left
      nameLabel.sizeToFit()
      cell.contentView.addSubview(nameLabel)
      
      let commitLabel = UILabel(frame: CGRect(x: 20, y: 8, width: cell.contentView.frame.width - 40, height: 32))
      commitLabel.text = String(currentUser.streak)
      commitLabel.textAlignment = .right
      commitLabel.font = UIFont(name: "Verdana", size: 32)
      commitLabel.textColor = .lightGray
      
      cell.contentView.addSubview(commitLabel)
      
      let profileImageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 40, height: 40))
      NetworkHelper.getProfilePictureFor(username: currentUser.name, completion: { url in
        if url != "" {
          profileImageView.af_setImage(withURL: URL(string: url)!)
        }
      })
      profileImageView.layer.cornerRadius = 20
      profileImageView.layer.borderWidth = 1
      profileImageView.layer.borderColor = UIColor.orange.cgColor
      profileImageView.clipsToBounds = true
      
      cell.contentView.addSubview(profileImageView)
      
      return cell
    }
}
