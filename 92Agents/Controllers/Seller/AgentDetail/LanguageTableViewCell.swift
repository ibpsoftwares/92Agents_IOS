//
//  LanguageTableViewCell.swift
//  92Agents
//
//  Created by Apple on 24/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

     @IBOutlet var lblLanguage: UILabel!
    @IBOutlet var lblSpeak: UILabel!
     @IBOutlet var lblRead: UILabel!
     @IBOutlet var lblWrite: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
