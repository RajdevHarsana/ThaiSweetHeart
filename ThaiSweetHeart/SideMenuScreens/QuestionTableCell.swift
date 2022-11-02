//
//  QuestionTableCell.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 26/02/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class QuestionTableCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var CheckImg: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
