//
//  DeleteMessagePopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 25/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class DeleteMessagePopUp: UIView {

    @IBOutlet weak var msglbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!

    var buttonYesHandler : (() -> Void)?
    var buttonNoHandler : (() -> Void)?
    
    class func intitiateFromNib() -> DeleteMessagePopUp {
        let View1 = UINib.init(nibName: "DeleteMessagePopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! DeleteMessagePopUp
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.msglbl.text = lang == "en" ? kmsglbl : kThmsglbl
        self.yesBtn.setTitle(lang == "en" ? kyesBtn : kThyesBtn, for: .normal)
        self.noBtn.setTitle(lang == "en" ? kNoButton : kThNoButton, for: .normal)
        self.topView.layer.cornerRadius = 20
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
