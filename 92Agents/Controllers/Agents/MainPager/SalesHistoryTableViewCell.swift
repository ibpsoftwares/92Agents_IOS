//
//  SalesHistoryTableViewCell.swift
//  92Agents
//
//  Created by Apple on 05/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SalesHistoryTableViewCell: UITableViewCell {

    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var textYear: UITextField!
    @IBOutlet var textSellerRepresnt: UITextField!
    @IBOutlet var textBuyerRepresnt: UITextField!
    @IBOutlet var textTotalSales: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
