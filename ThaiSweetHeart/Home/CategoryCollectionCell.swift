//
//  CategoryCollectionCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 31/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var BottomLineLbl: UILabel!
    @IBOutlet weak var bottomLinelblwidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
