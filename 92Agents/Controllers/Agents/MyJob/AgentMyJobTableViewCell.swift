//
//  AgentMyJobTableViewCell.swift
//  92Agents
//
//  Created by Apple on 05/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AgentMyJobTableViewCell: UITableViewCell {

    @IBOutlet var lblPostTitle: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var lblDate: UILabel!
     @IBOutlet var lblActiveAgent: UILabel!
     @IBOutlet var lblNewMsg: UILabel!
     @IBOutlet var lblNotification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
