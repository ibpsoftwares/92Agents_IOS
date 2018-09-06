//
//  SellerTestTableViewCell.swift
//  92Agents
//
//  Created by Apple on 02/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SellerTestTableViewCell: UITableViewCell {

    @IBOutlet var lblQuestion: UILabel!
     @IBOutlet var lblNo: UILabel!
    @IBOutlet var btnAnswer: UIButton!
    @IBOutlet var textAns: UITextField!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var ansView: UIView!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
