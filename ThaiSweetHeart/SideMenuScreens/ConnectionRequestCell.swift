//
//  ConnectionRequestCell.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 28/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class ConnectionRequestCell: UITableViewCell {

    @IBOutlet weak var userimage: MyImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userdes: UILabel!
    @IBOutlet weak var likeBtn: MyButton!
    @IBOutlet weak var dislikebtn: MyButton!
    @IBOutlet weak var agelbl: UILabel!
    @IBOutlet weak var Goldimage: UIImageView!
    @IBOutlet weak var SuperlikeImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
