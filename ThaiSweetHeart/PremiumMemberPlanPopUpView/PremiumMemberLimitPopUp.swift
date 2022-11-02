//
//  PremiumMemberLimitPopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 23/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class PremiumMemberLimitPopUp: UIView {

    @IBOutlet weak var limitMsgLbl: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okayBtn: UIButton!
    
    var buttonCancelHandler : (() -> Void)?
    
    class func intitiateFromNib() -> PremiumMemberLimitPopUp {
        let View1 = UINib.init(nibName: "PremiumMemberLimitPopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! PremiumMemberLimitPopUp
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.limitMsgLbl.text = lang == "en" ? klimitMsgLbl : kThlimitMsgLbl
        self.okayBtn.setTitle(lang == "en" ? kokayBtn : kThokayBtn, for: .normal)
        self.popUpView.layer.cornerRadius = 20
        self.okayBtn.layer.cornerRadius = 8
    }
    
    
    @IBAction func okayBtnAction(_ sender: UIButton) {
        buttonCancelHandler?()
    }

}
