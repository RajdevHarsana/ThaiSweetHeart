//
//  UserSearchVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 18/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class UserSearchVC: BaseViewController {

    @IBOutlet weak var searchCityNameTxt: UITextField!
    @IBOutlet weak var searchBtn: MyButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        self.ChangeLanguage(language: lang)
//        self.title = "Search Here"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: lang == "en" ? kcancelBtn : kThcancelBtn, style: .plain, target: self, action: #selector(CrossButtonAction))
        
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
        bar_title.text = language == "en" ? ksearchTitle : kThsearchTitle
        self.searchCityNameTxt.placeholder = language == "en" ? ksearchCityNameTxt : kThsearchCityNameTxt
        self.searchBtn.setTitle(language == "en" ? kExplore : kThexplore, for: .normal)
    }
    
    @objc func CrossButtonAction(_ sender: ResponsiveButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func SearchButtonAction(_ sender: MyButton) {
        let vc = SearchVC(nibName: "SearchVC", bundle: nil)
        vc.SearchText = self.searchCityNameTxt.text ?? ""
        self.onlyPushViewController(vc)
    }
    
}
