//
//  SurveyQuesTableViewCell.swift
//  92Agents
//
//  Created by Apple on 26/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SurveyQuesTableViewCell: UITableViewCell {

    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var lblNo: UILabel!
    @IBOutlet var btnDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
