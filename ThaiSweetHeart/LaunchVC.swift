//
//  LaunchVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 24/02/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class LaunchVC: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAVPlayer()  // Call method to setup AVPlayer & AVPlayerLayer to play video
    }
    
    func setupAVPlayer() {

        let videoURL = Bundle.main.url(forResource: "splash", withExtension: "mp4") // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        avPlayerLayer.frame = self.view.bounds // Set bounds of avPlayerLayer
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        avPlayer.play() // Play video
        
        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in
            
            if time == avAssets.duration {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
                let leftController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController

                let slideMenuController = SlideMenuController(mainViewController: UINavigationController(rootViewController:initialViewController), leftMenuViewController: leftController)
                slideMenuController.delegate = initialViewController
                self?.appDelegate.window?.rootViewController = slideMenuController
            }
        }
    }
}
