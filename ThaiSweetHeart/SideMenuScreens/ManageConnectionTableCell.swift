//
//  ManageConnectionTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class ManageConnectionTableCell: UITableViewCell {

    @IBOutlet weak var imgView: MyImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var chatButton: MyButton!
    @IBOutlet weak var removeButton: MyButton!
    @IBOutlet weak var goldMemberIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
