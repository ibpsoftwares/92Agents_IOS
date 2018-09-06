//
//  DashBoardTableViewCell.swift
//  92Agents
//
//  Created by Apple on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DashBoardTableViewCell: UITableViewCell {

    @IBOutlet var textPost: UILabel!
    @IBOutlet var textAgent: UILabel!
     @IBOutlet var lbl: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
