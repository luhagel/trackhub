//
//  SettingsTableViewCell.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/14/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
