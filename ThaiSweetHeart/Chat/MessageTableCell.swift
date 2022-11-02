//
//  MessageTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {

    @IBOutlet weak var userimage: MyImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var messageTxt: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var goldMemberIcon: UIImageView!
    @IBOutlet weak var SuperLikeImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userimage.layer.cornerRadius = 32
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
