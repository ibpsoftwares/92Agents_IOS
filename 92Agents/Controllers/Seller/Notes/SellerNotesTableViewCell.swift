//
//  SellerNotesTableViewCell.swift
//  92Agents
//
//  Created by Apple on 02/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SellerNotesTableViewCell: UITableViewCell {

    @IBOutlet var textPost: UILabel!
    @IBOutlet var textProposal: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textNotes: UILabel!
    @IBOutlet var btnEdit: UIButton!
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
