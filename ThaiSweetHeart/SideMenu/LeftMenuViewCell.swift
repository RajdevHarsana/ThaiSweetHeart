//
//  LeftMenuViewCell.swift
//  Samksa
//
//  Created by Mac Mini on 17/12/14.
//  Copyright (c) 2014 Fullestop. All rights reserved.

import UIKit

class LeftMenuViewCell: UITableViewCell {

    @IBOutlet var ImgVw: UIImageView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet weak var CountLbl: MyLabel!
    @IBOutlet var countLable: UILabel!
    @IBOutlet weak var goldMemberImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
