//
//  VideoCollectionCell.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 18/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var playButton: ResponsiveButton!
    var player = AVPlayer()
    var avpController = AVPlayerViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 8
        // Initialization code
    }

}
