//
//  AgentTableViewCell.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AgentTableViewCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDecription: UILabel!
    @IBOutlet var agentImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
