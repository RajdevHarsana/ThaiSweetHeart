//
//  UpgradePlan.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 23/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class UpgradePlan: UIView {

    @IBOutlet weak var upgradePlanLbl: UILabel!
    @IBOutlet weak var upgradePlanMsgLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    var buttonbuyHandler : (() -> Void)?
    var buttonCancelHandler : (() -> Void)?
    
    class func intitiateFromNib() -> UpgradePlan {
        let View1 = UINib.init(nibName: "UpgradePlan", bundle: nil).instantiate(withOwner: self, options: nil).first as! UpgradePlan
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.upgradePlanLbl.text = lang == "en" ? kupgradePlanLbl : kThupgradePlanLbl
        self.upgradePlanMsgLbl.text = lang == "en" ? kupgradePlanMsgLbl : kThupgradePlanMsgLbl
        self.buyBtn.setTitle(lang == "en" ? kbuyBtn : kThbuyBtn, for: .normal)
        self.cancelBtn.setTitle(lang == "en" ? kcancelBtn : kThcancelBtn, for: .normal)
        self.topView.layer.cornerRadius = 20
        self.buyBtn.layer.cornerRadius = 8
        self.cancelBtn.layer.cornerRadius = 8
    }
    
    
    @IBAction func buyBtnAction(_ sender: UIButton) {
        buttonbuyHandler?()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        buttonCancelHandler?()
    }

}
