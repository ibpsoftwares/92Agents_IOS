//
//  FindAgentTableViewCell.swift
//  92Agents
//
//  Created by Apple on 04/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import TagListView
import TagListView.Swift

class FindAgentTableViewCell: UITableViewCell ,TagListViewDelegate{
     @IBOutlet  var tagListView: TagListView!
     @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblState: UILabel!
     @IBOutlet var lblDate: UILabel!
     @IBOutlet var lblExperiencee: UILabel!
     @IBOutlet var lbleDesrcription: UILabel!
     @IBOutlet var agentImg: UIImageView!
     @IBOutlet var lblOnlineStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
