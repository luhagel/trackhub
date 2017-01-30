//
//  BarChartTableViewCell.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/13/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class BarChartTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    let chartviews = self.contentView.subviews.filter{$0 is BarChartBarView}
    for chart in chartviews {
        chart.removeFromSuperview()
    }
    let labels = self.contentView.subviews.filter{$0 is UILabel}
    for label in labels {
      label.removeFromSuperview()
    }
  }
}
