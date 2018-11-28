//
//  DocumentTableViewCell.swift
//  92Agents
//
//  Created by Apple on 16/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

     @IBOutlet var lblDocName: UILabel!
     @IBOutlet var imageDoc: UIImageView!
     @IBOutlet var btnDelete: UIButton!
     @IBOutlet var btnViewProposal: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
