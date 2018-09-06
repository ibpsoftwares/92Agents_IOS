//
//  AgentDetailTableViewCell.swift
//  92Agents
//
//  Created by Apple on 11/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AgentDetailTableViewCell: UITableViewCell {

      @IBOutlet var lblPostName: UILabel!
      @IBOutlet var lblDate: UILabel!
      @IBOutlet var lblOrgName: UILabel!
      @IBOutlet var lblDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
