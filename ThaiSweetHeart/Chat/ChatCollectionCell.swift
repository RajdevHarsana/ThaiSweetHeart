//
//  ChatCollectionCell.swift
//  ThaiSweetHeart
//
//  Created by MAC-30 on 28/08/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class ChatCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var gold_icon: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.frame.height/2
    }
}
