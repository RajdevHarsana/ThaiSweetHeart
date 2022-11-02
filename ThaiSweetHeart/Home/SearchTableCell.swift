//
//  SearchTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet weak var userimage: MyImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var deslbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var viewdetailBtn: MyButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
