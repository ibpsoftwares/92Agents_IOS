//
//  ProfessLanguageTableViewCell.swift
//  92Agents
//
//  Created by Apple on 06/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProfessLanguageTableViewCell: UITableViewCell {

    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var textLang: UITextField!
    @IBOutlet var textSpeak: UITextField!
    @IBOutlet var textRead: UITextField!
    @IBOutlet var textWrite: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
