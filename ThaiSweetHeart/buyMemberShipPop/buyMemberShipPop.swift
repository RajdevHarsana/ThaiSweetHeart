//
//  buyMemberShipPop.swift
//  ThaiSweetHeart
//
//  Created by MAC-30 on 04/09/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class buyMemberShipPop: UIView {

    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popImgView: UIImageView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    
    var buttonYesHandler : (() -> Void)?
    var buttonNoHandler : (() -> Void)?
    
    class func intitiateFromNib() -> buyMemberShipPop {
        let View1 = UINib.init(nibName: "buyMemberShipPop", bundle: nil).instantiate(withOwner: self, options: nil).first as! buyMemberShipPop
        
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.yesBtn.setTitle(lang == "en" ? kbuyBtn : kThbuyBtn, for: .normal)
//        self.noBtn.setTitle(lang == "en" ? kcancelBtn : kThcancelBtn, for: .normal)
        self.popUpView.layer.cornerRadius = 20
        self.popImgView.layer.cornerRadius = 8
        self.yesBtn.layer.cornerRadius = 8
        self.noBtn.layer.cornerRadius = 8
    }
    
    @IBAction func yesBtnAction(_ sender: UIButton) {
        buttonYesHandler?()
    }
    
    @IBAction func noBtnAction(_ sender: UIButton) {
        buttonNoHandler?()
    }
}
