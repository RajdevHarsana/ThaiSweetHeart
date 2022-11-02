//
//  NotificationTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 18/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    @IBOutlet weak var imgView: MyImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
