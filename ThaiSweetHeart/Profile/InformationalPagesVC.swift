//
//  InformationalPagesVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 06/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class InformationalPagesVC: BaseViewSideMenuController {

    @IBOutlet weak var aboutUsBtn: UIButton!
    @IBOutlet weak var howitworkBtn: UIButton!
    @IBOutlet weak var faqBtb: UIButton!
    @IBOutlet weak var saftyTipsBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var policyBtn: UIButton!
    var menuBarBtn = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
//        self.title = "Informational Pages"
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
        
        aboutUsBtn.layer.cornerRadius = 6
        aboutUsBtn.layer.borderWidth = 1
        aboutUsBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        
        howitworkBtn.layer.cornerRadius = 6
        howitworkBtn.layer.borderWidth = 1
        howitworkBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        faqBtb.layer.cornerRadius = 6
        faqBtb.layer.borderWidth = 1
        faqBtb.layer.borderColor = UIColor.lightGray.cgColor
        
        saftyTipsBtn.layer.cornerRadius = 6
        saftyTipsBtn.layer.borderWidth = 1
        saftyTipsBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        termsBtn.layer.cornerRadius = 6
        termsBtn.layer.borderWidth = 1
        termsBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        policyBtn.layer.cornerRadius = 6
        policyBtn.layer.borderWidth = 1
        policyBtn.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }

    //MARK:- Change Language Function
    func ChangeLanguage(language:String){
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        self.navigationItem.titleView = bar_title
        bar_title.text = language == "en" ? kInformationalTitle : kThInformationalTitle
        self.aboutUsBtn.setTitle(language == "en" ? kaboutUsBtn : kThaboutUsBtn, for: .normal)
        self.howitworkBtn.setTitle(language == "en" ? khowitworkBtn : kThhowitworkBtn, for: .normal)
        self.faqBtb.setTitle(language == "en" ? kfaqBtb : kThfaqBtb, for: .normal)
        self.saftyTipsBtn.setTitle(language == "en" ? ksaftyTipsBtn : kThsaftyTipsBtn, for: .normal)
        self.termsBtn.setTitle(language == "en" ? ktermsBtn : kThtermsBtn, for: .normal)
        self.policyBtn.setTitle(language == "en" ? kpolicyBtn : kThpolicyBtn, for: .normal)
    }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    @IBAction func aboutBtnAction(_ sender: Any) {
        let vc = WebviewPagesVC(nibName: "WebviewPagesVC", bundle: nil)
        vc.webtype = "about"
        vc.title = "About Us"
        self.onlyPushViewController(vc)
    }
    @IBAction func howItworkBtnAction(_ sender: Any) {
        let vc = WebviewPagesVC(nibName: "WebviewPagesVC", bundle: nil)
        vc.webtype = "how"
        vc.title = "How it works"
        self.onlyPushViewController(vc)
    }
    @IBAction func faqBtnAction(_ sender: Any) {
        let vc = WebviewPagesVC(nibName: "WebviewPagesVC", bundle: nil)
        vc.webtype = "faq"
        vc.title = "FAQ"
        self.onlyPushViewController(vc)
    }
    @IBAction func safttyBtnAction(_ sender: Any) {
        let vc = WebviewPagesVC(nibName: "WebviewPagesVC", bundle: nil)
        vc.webtype = "safety"
        vc.title = "Safety tips"
        self.onlyPushViewController(vc)
    }
    
    @IBAction func termsBtnAction(_ sender: Any) {
        let vc = WebviewPagesVC(nibName: "WebviewPagesVC", bundle: nil)
        vc.webtype = "terms"
        vc.title = "Terms & Conditions"
        self.onlyPushViewController(vc)
    }
    
    @IBAction func policyBtnAction(_ sender: Any) {
        let vc = WebviewPagesVC(nibName: "WebviewPagesVC", bundle: nil)
        vc.webtype = "privacy"
        vc.title = "Privacy policy"
        self.onlyPushViewController(vc)
    }

}
