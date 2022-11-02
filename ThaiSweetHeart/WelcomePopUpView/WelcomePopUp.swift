//
//  WelcomePopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 16/02/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class WelcomePopUp: UIView {

    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var okayBtn: UIButton!
    @IBOutlet weak var welocomeLbl: UILabel!
    @IBOutlet weak var welcomeMsgLbl: UILabel!
    
    var buttonCancelHandler : (() -> Void)?
    
    class func intitiateFromNib() -> WelcomePopUp {
        let View1 = UINib.init(nibName: "WelcomePopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! WelcomePopUp
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.popUpView.layer.cornerRadius = 20
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.welocomeLbl.text = lang == "en" ? kwelocomeLbl : kThwelocomeLbl
        self.welcomeMsgLbl.text = lang == "en" ? kwelcomeMsgLbl : kThwelcomeMsgLbl
        self.okayBtn.setTitle(lang == "en" ? kokayBtn : kThokayBtn, for: .normal)
        self.logoImage.layer.cornerRadius = CGFloat(signOf: self.logoImage.frame.size.width / 2, magnitudeOf: self.logoImage.frame.size.height / 2)
        self.okayBtn.layer.cornerRadius = 8
    }
    
    
    @IBAction func okayBtnAction(_ sender: UIButton) {
        buttonCancelHandler?()
    }
    
}
