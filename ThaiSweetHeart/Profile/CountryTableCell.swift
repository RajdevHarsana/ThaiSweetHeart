//
//  CountryTableCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 11/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class CountryTableCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var CheckImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
