//
//  BarChartBarView.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/13/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class BarChartBarView: UIView {
  
  init(frame: CGRect, color: UIColor, username: String, commits: Int) {
    super.init(frame: frame)
    self.backgroundColor = color
    let nameLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 200, height: 18))
    nameLabel.text = "-> \(commits)"
    nameLabel.textColor = .white
    nameLabel.sizeToFit()
    self.addSubview(nameLabel)
    self.layer.cornerRadius = 2
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
