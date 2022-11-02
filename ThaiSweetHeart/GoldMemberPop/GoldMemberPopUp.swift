//
//  GoldMemberPopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 03/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class GoldMemberPopUp: UIView {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popImgView: UIImageView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var goldMembershipLbl: UILabel!
    @IBOutlet weak var goldMembershipMsgLbl: UILabel!
    
    var buttonbuyHandler : (() -> Void)?
    var buttonCancelHandler : (() -> Void)?
    
    class func intitiateFromNib() -> GoldMemberPopUp {
        let View1 = UINib.init(nibName: "GoldMemberPopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! GoldMemberPopUp
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.goldMembershipLbl.text = lang == "en" ? kgoldMembershipLbl : kThgoldMembershipLbl
        self.goldMembershipMsgLbl.text = lang == "en" ? kgoldMembershipMsgLbl : kThgoldMembershipMsgLbl
        self.buyBtn.setTitle(lang == "en" ? kbuyBtn : kThbuyBtn, for: .normal)
        self.cancelBtn.setTitle(lang == "en" ? kcancelBtn : kThcancelBtn, for: .normal)
        self.popUpView.layer.cornerRadius = 20
        self.popImgView.layer.cornerRadius = 8
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
