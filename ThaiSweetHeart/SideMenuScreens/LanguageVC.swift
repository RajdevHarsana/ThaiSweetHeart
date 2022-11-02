//
//  LanguageVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class LanguageVC: BaseViewSideMenuController {

    @IBOutlet weak var englishLbl: UILabel!
    @IBOutlet weak var thaiLbl: UILabel!
    @IBOutlet weak var englishLangSwitchBtn: UISwitch!
    @IBOutlet weak var thaiLangSwitchBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        
        if lang == "en"{
            thaiLangSwitchBtn.setOn(false, animated:true)
            englishLangSwitchBtn.setOn(true, animated:true)
        }else{
            thaiLangSwitchBtn.setOn(true, animated:true)
            englishLangSwitchBtn.setOn(false, animated:true)
        }
        
        self.changeLanguage(Language: lang)
    }

    @IBAction func englishLangBtn(_ sender: UISwitch) {
        if sender.isOn == true{
            thaiLangSwitchBtn.setOn(false, animated:true)
            englishLangSwitchBtn.setOn(true, animated:true)
        }else{
            englishLangSwitchBtn.setOn(true, animated: true)
        }
        self.changeLanguage(Language: "en")
    }
    @IBAction func thaiLangBtn(_ sender: UISwitch) {
        if sender.isOn == true{
            thaiLangSwitchBtn.setOn(true, animated:true)
            englishLangSwitchBtn.setOn(false, animated:true)
        }else{
            thaiLangSwitchBtn.setOn(true, animated: true)
        }
        self.changeLanguage(Language: "th")
    }
    
    func changeLanguage(Language:String){
//        self.englishLbl.text = Language == "en" ? kEnglish : kThEnglish
        self.thaiLbl.text = Language == "en" ? kThai : kThThai
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        
        bar_title.text = Language == "en" ? kLanguageCHange : kThLanguageCHange
        Config().AppUserDefaults.setValue(Language, forKey: "Language")
        
    }
    
}
