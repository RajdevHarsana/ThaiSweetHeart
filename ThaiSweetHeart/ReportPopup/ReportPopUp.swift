//
//  ReportPopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 14/07/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class ReportPopUp: UIView,UITextViewDelegate {

    @IBOutlet weak var msglbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
//    @IBOutlet weak var reportTxtFeild: UITextField!
    @IBOutlet weak var reportTxtFeild: UITextView!
    
    var buttonYesHandler : (() -> Void)?
    var buttonNoHandler : (() -> Void)?
    
    class func intitiateFromNib() -> ReportPopUp {
        let View1 = UINib.init(nibName: "ReportPopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! ReportPopUp
        
        return View1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.reportTxtFeild.layer.cornerRadius = 6
        self.reportTxtFeild.layer.borderWidth = 0.5
        self.reportTxtFeild.layer.borderColor = UIColor.lightGray.cgColor
//        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.msglbl.text = lang == "en" ? kmsglbl : kThmsglbl
//        self.yesBtn.setTitle(lang == "en" ? kyesBtn : kThyesBtn, for: .normal)
//        self.noBtn.setTitle(lang == "en" ? kNoButton : kThNoButton, for: .normal)
        self.topView.layer.cornerRadius = 8
        self.yesBtn.layer.cornerRadius = 8
        self.noBtn.layer.cornerRadius = 8
        if self.reportTxtFeild.text == "" {
            self.reportTxtFeild.text = "Reason"
        }
    }
    @IBAction func yesBtnAction(_ sender: UIButton) {
        buttonYesHandler?()
    }
    
    @IBAction func noBtnAction(_ sender: UIButton) {
        buttonNoHandler?()
    }

}
