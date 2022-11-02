//
//  receiveGifCell.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 01/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class receiveGifCell: UITableViewCell {
    
    
    @IBOutlet weak var gifIMage: UIImageView!
    @IBOutlet weak var timeDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
          accessoryType = .checkmark
        } else {
          accessoryType = .none
        }
        // Configure the view for the selected state
    }
    
}
