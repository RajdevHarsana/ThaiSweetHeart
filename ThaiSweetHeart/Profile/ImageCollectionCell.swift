//
//  ImageCollectionCell.swift
//  PartyPlan
//
//  Created by mac-15 on 20/10/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var crossBtnView: UIView!
    @IBOutlet weak var CrossButton: ResponsiveButton!
    @IBOutlet weak var crossImgbk: UIImageView!
    
    var player = AVPlayer()
    var avpController = AVPlayerViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.CrossButton.layer.cornerRadius = 10
        self.crossImgbk.layer.cornerRadius = 10
        // Initialization code
    }

}
