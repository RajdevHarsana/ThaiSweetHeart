//
//  GoldLikePopUp.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 08/07/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class GoldLikePopUp: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var buttonDoneHandler : (() -> Void)?
    
    class func intitiateFromNib() -> GoldLikePopUp {
        let View1 = UINib.init(nibName: "GoldLikePopUp", bundle: nil).instantiate(withOwner: self, options: nil).first as! GoldLikePopUp
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
//        self.titleLbl.text = lang == "en" ? kRequestVerifyTitle : kThRequestVerifyTitle
//        self.messageLbl.text = lang == "en" ? kRequestVerifyMsgLbl : kThRequestVerifyMsgLbl
        self.imageView.layer.cornerRadius = CGFloat(signOf: self.imageView.frame.size.width / 2, magnitudeOf: self.imageView.frame.size.height / 2)
//        self.popUpView.layer.cornerRadius = 20
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        buttonDoneHandler?()
    }
}
