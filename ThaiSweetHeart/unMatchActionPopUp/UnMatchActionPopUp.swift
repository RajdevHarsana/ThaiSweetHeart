//
//  UnMatchActionPopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-30 on 09/09/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class UnMatchActionPopUp: UIView {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtnView: UIView!
    @IBOutlet weak var noBtnView: UIView!
    @IBOutlet weak var noimg: UIImageView!
    @IBOutlet weak var yesimg: UIImageView!
    
    
    var buttonYesHandler : (() -> Void)?
    var buttonNoHandler : (() -> Void)?
    
    class func intitiateFromNib() -> UnMatchActionPopUp {
        let View1 = UINib.init(nibName: "UnMatchActionPopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! UnMatchActionPopUp
        
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.yesBtn.setTitle(lang == "en" ? kbuyBtn : kThbuyBtn, for: .normal)
//        self.noBtn.setTitle(lang == "en" ? kcancelBtn : kThcancelBtn, for: .normal)
        self.popUpView.layer.cornerRadius = 20
        self.yesBtnView.layer.cornerRadius = 5
        self.noBtnView.layer.cornerRadius = 5
        self.noimg.layer.cornerRadius = 5
        self.yesimg.layer.cornerRadius = 5
    }
    @IBAction func yesBtnAction(_ sender: UIButton) {
        buttonYesHandler?()
    }
    
    @IBAction func noBtnAction(_ sender: UIButton) {
        buttonNoHandler?()
    }
}
