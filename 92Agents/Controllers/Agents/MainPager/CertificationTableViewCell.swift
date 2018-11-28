//
//  CertificationTableViewCell.swift
//  92Agents
//
//  Created by Apple on 14/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CertificationTableViewCell: UITableViewCell {

     @IBOutlet var btnSelect: UIButton!
     @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
