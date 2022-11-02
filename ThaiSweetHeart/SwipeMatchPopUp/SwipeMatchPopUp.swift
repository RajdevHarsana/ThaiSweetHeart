//
//  SwipeMatchPopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-30 on 30/08/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class SwipeMatchPopUp: UIView {
    
    @IBOutlet weak var sendMsgBtn: UIButton!
    @IBOutlet weak var keepSwipingBtn: UIButton!
    
    var sendMsgHandler : (() -> Void)?
    var KeepSwipingHandler : (() -> Void)?
    
    class func intitiateFromNib() -> SwipeMatchPopUp {
        let View1 = UINib.init(nibName: "SwipeMatchPopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! SwipeMatchPopUp
        
        return View1
    }
    
    @IBAction func sendMsgBtnAction(_ sender: Any) {
        sendMsgHandler?()
    }
    @IBAction func keepSwipingBtnAction(_ sender: Any) {
        KeepSwipingHandler?()
    }
}
