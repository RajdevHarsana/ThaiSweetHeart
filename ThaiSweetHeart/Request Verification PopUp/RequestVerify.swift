//
//  RequestVerify.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 24/06/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class RequestVerify: UIView {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var okayBtn: UIButton!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var MsgLbl: UILabel!
    
    var buttonDoneHandler : (() -> Void)?
    
    class func intitiateFromNib() -> RequestVerify {
        let View1 = UINib.init(nibName: "RequestVerify", bundle: nil).instantiate(withOwner: self, options: nil).first as! RequestVerify
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.TitleLbl.text = lang == "en" ? kRequestVerifyTitle : kThRequestVerifyTitle
        self.MsgLbl.text = lang == "en" ? kRequestVerifyMsgLbl : kThRequestVerifyMsgLbl
        self.okayBtn.setTitle(lang == "en" ? kRequestVerifyOkayBtn : kThRequestVerifyOkayBtn, for: .normal)
        self.logoImage.layer.cornerRadius = CGFloat(signOf: self.logoImage.frame.size.width / 2, magnitudeOf: self.logoImage.frame.size.height / 2)
        self.popUpView.layer.cornerRadius = 20
        self.okayBtn.layer.cornerRadius = 8
    }
    
    
    @IBAction func okayBtnAction(_ sender: UIButton) {
        buttonDoneHandler?()
    }

}
