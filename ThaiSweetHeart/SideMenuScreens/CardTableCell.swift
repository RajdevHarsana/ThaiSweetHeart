//
//  CardTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class CardTableCell: UITableViewCell {

    @IBOutlet weak var BackView: MyView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var expireLbl: UILabel!
    @IBOutlet weak var editBtn: ResponsiveButton!
    @IBOutlet weak var deleteBtn: ResponsiveButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
