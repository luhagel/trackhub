//
//  BarChartBarView.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/13/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class BarChartBarView: UIView {
  
  init(frame: CGRect, color: UIColor) {
    super.init(frame: frame)
    self.backgroundColor = color
    self.layer.cornerRadius = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
