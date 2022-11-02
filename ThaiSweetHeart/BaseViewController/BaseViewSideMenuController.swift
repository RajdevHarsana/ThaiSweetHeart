//
//  BaseViewTabBarController.swift
//  Aprendo
//
//  Created by mac-15 on 01/05/19.
//  Copyright © 2019 mac-15. All rights reserved.
//

import UIKit

class BaseViewSideMenuController: UIViewController , UITextFieldDelegate{
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as? String ?? ""
    var user_image = DataManager.getVal(Config().AppUserDefaults.value(forKey: "User_Img")) as? String ?? ""
    var user_name = DataManager.getVal(Config().AppUserDefaults.value(forKey: "User_Name")) as? String ?? ""
    var leftBarButton = ResponsiveButton()
    var leftmenubutton = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.leftItemsSupplementBackButton = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font:Config().AppGlobalFont(18, isBold: true),NSAttributedString.Key.foregroundColor: UIColor.white]

        let leftmenuImage = UIImage(named: "menu")
        let leftmenuFrameimg = CGRect(x: 0, y: 0,width: 35,height: 30)
        self.leftBarButton = ResponsiveButton(frame: leftmenuFrameimg)
        self.leftBarButton.setImage(leftmenuImage, for: UIControl.State())
        self.leftBarButton.showsTouchWhenHighlighted = true
        self.leftBarButton.addTarget(self, action: #selector(self.SideMenuButtonAction), for: UIControl.Event.touchUpInside)
        
        self.leftmenubutton.customView = self.leftBarButton
        
        self.navigationItem.leftBarButtonItem = self.leftmenubutton
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    @objc func SideMenuButtonAction(_ selector: ResponsiveButton){
        self.slideMenuController()?.toggleLeft()
    }

}

