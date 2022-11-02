//
//  NotificationSettingVC.swift
//  ThaiSweetHeart
//
//  Created by mac-15 on 02/11/20.
//  Copyright © 2020 mac-15. All rights reserved.
//

import UIKit

class NotificationSettingVC: BaseViewSideMenuController {
    
    @IBOutlet weak var emailNotiLbl: UILabel!
    @IBOutlet weak var inAppNotiLbl: UILabel!
    @IBOutlet weak var EmailSwitch: UISwitch!
    @IBOutlet weak var InAppSwitch: UISwitch!
    var email = String()
    var inApp = String()
    var menuBarBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        
        let ChatImage : UIImage? = UIImage(named:"back-btn")?.withRenderingMode(.alwaysOriginal)
        self.menuBarBtn = UIBarButtonItem(image: ChatImage, style: .plain, target: self, action: #selector(backMenu))
        self.navigationItem.leftBarButtonItem = self.menuBarBtn
        
        let lang = Config().AppUserDefaults.value(forKey: "Language") as? String ?? "en"
        
        let bar_title  = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        bar_title.textColor = UIColor.white
        bar_title.numberOfLines = 0
        bar_title.center = CGPoint(x: 0, y: 0)
        bar_title.textAlignment = .left
        bar_title.font = UIFont.boldSystemFont(ofSize: bar_title.font.pointSize)
        bar_title.text = "Details"
        self.navigationItem.titleView = bar_title
        bar_title.text = lang == "en" ? kNotification_Setting : kThNotification_Setting
//        self.title = "Notification Settings"
        self.emailNotiLbl.text = lang == "en" ? kemailNotiLbl : kThemailNotiLbl
        self.inAppNotiLbl.text = lang == "en" ? kinAppNotiLbl : kThinAppNotiLbl
        self.getSettingApi()
    }
    func getSettingApi(){
        self.pleaseWait()
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(self.user_id, forKey: "user_id")
        
        let methodName = "notification/setting/view"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                
                if status == "1" {
                    if let setting = DataManager.getVal(responseData?.object(forKey: "setting")) as? NSDictionary{
                        self.email = DataManager.getVal(setting["email"]) as? String ?? ""
                        self.inApp = DataManager.getVal(setting["push_notification"]) as? String ?? ""
                        if self.email == "1"{
                            self.EmailSwitch.setOn(true, animated: true)
                        }else{
                            self.EmailSwitch.setOn(false, animated: true)
                        }
                        if self.inApp == "1"{
                            self.InAppSwitch.setOn(true, animated: true)
                        }else{
                            self.InAppSwitch.setOn(false, animated: true)
                        }
                    }
                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            })
        }
    }
    @IBAction func EmailSwitchAction(_ sender: UISwitch) {
        if sender.isOn == true{
            self.email = "1"
            self.notificationSettingEditAPI(email: self.email,inApp: self.inApp)
        }else{
            self.email = "0"
            self.notificationSettingEditAPI(email: self.email,inApp: self.inApp)
        }
    }
    @IBAction func InAppSwitchAction(_ sender: UISwitch) {
        if sender.isOn == true{
            self.inApp = "1"
            self.notificationSettingEditAPI(email: self.email,inApp: self.inApp)
        }else{
            self.inApp = "0"
            self.notificationSettingEditAPI(email: self.email,inApp: self.inApp)
        }
    }
    @objc func backMenu(){
        self.slideMenuController()?.toggleLeft()
    }
    
    func notificationSettingEditAPI(email: String,inApp: String){
        self.pleaseWait()
        
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(self.user_id, forKey: "user_id")
        parameterDictionary.setValue(email, forKey: "email")
        parameterDictionary.setValue(inApp, forKey: "push_notification")
        
        let methodName = "notification/setting/edit"
        
        DataManager.getAPIResponse(parameterDictionary,methodName: methodName, methodType: "POST") { (responseData,error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                let status = DataManager.getVal(responseData?.object(forKey: "status")) as? String ?? ""
                let message = DataManager.getVal(responseData?.object(forKey: "message")) as? String ?? ""
                
                if status == "1" {

                }else{
                    self.view.makeToast(message: message)
                }
                self.clearAllNotice()
            })
        }
    }
}
