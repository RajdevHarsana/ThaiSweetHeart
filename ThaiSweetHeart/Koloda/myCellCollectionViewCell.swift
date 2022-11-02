//
//  myCellCollectionViewCell.swift
//  Koloda_Example
//
//  Created by mac-14 on 15/03/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class myCellCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lbl_data: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.image.layer.cornerRadius = 8
    }

}
