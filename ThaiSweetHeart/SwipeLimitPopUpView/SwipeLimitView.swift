//
//  SwipeLimitView.swift
//  ThaiSweetHeart
//
//  Created by MAC-27 on 22/03/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class SwipeLimitView: UIView {

    @IBOutlet weak var outOfSwipeLbl: UILabel!
    @IBOutlet weak var outOfSwipeMsgLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var buttonbuyHandler : (() -> Void)?
    var buttonCancelHandler : (() -> Void)?
    
    class func intitiateFromNib() -> SwipeLimitView {
        let View1 = UINib.init(nibName: "SwipeLimitView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SwipeLimitView
        
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.outOfSwipeLbl.text = lang == "en" ? koutOfSwipeLbl : kThoutOfSwipeLbl
        self.outOfSwipeMsgLbl.text = lang == "en" ? koutOfSwipeMsgLbl : kThoutOfSwipeMsgLbl
        self.buyBtn.setTitle(lang == "en" ? kbuyBtn : kThbuyBtn, for: .normal)
        self.cancelBtn.setTitle(lang == "en" ? kcancelBtn : kThcancelBtn, for: .normal)
        self.contentView.layer.cornerRadius = 20
        self.iconImg.layer.cornerRadius = self.iconImg.frame.height / 2
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
