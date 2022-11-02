//
//  LunchVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 24/02/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class LunchVC: UIViewController {

    var player: AVPlayer?
    var avpController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func loadVideo() {

        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "psd design_1", ofType:"mp4")

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
        avpController = AVPlayerViewController()
        avpController.player = player
        avpController.view.frame.size.width = imgView.frame.size.width
        avpController.view.frame.size.height = imgView.frame.size.height
        self.addChild(avpController)
        
        imgView.addSubview(avpController.view)
        
        self.view.layer.addSublayer(playerLayer)

        player?.seek(to: CMTime.zero)
        player?.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
