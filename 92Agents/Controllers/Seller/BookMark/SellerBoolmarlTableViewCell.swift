//
//  SellerBoolmarlTableViewCell.swift
//  92Agents
//
//  Created by Apple on 28/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SellerBoolmarlTableViewCell: UITableViewCell {

    @IBOutlet var textPost: UILabel!
    @IBOutlet var textBookmark: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
     @IBOutlet var testView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
