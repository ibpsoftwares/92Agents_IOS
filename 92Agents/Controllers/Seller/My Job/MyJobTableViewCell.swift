//
//  MyJobTableViewCell.swift
//  92Agents
//
//  Created by Apple on 29/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MyJobTableViewCell: UITableViewCell {

     @IBOutlet var lblPostTitle: UILabel!
     @IBOutlet var lblAddress: UILabel!
     @IBOutlet var lblDetail: UILabel!
     @IBOutlet var lblDate: UILabel!
     @IBOutlet var btnAgentCount: UIButton!
     @IBOutlet var btnEditPost: UIButton!
      @IBOutlet var btnDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
